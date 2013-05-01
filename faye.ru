require "faye"
require "faye/redis"
require "mongoid"
require(File.expand_path("../app/models/application.rb", __FILE__))

Faye::WebSocket.load_adapter("thin")
Mongoid.load!(File.expand_path("../config/mongoid.yml", __FILE__), :production)

class ServerAuth
  def incoming(message, callback)
    if message["channel"] !~ %r{^/meta/}
      if (application = Application.find_by_auth(message["ext"]["secret_id"], message["ext"]["secret_token"])).nil?
        puts message.inspect
        message["error"] = "Authentication required"
      else
        application.add_request!
      end
    end
    callback.call(message)
  end

  def outgoing(message, callback)
    if message["ext"]
      message["ext"] = {}
    end
    callback.call(message)
  end
end

server = Faye::RackAdapter.new(
    :mount   => "/stream",
    :timeout => 25,
    :engine => {
        :type => Faye::Redis,
        :host => "localhost",
        :port => 6379
    }
)

server.add_extension(ServerAuth.new)

run server