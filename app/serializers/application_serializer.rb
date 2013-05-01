class ApplicationSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :secret_id, :secret_token
end
