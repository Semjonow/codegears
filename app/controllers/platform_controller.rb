class PlatformController < ApplicationController
  def index
    render :json => { :CG => Time.current.to_i }
  end
end