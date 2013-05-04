class Application
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email,               :type => String,  :default => ""
  field :secret_id,           :type => String,  :default => ""
  field :secret_token,        :type => String,  :default => ""
  field :active,              :type => Boolean, :default => true
  field :num_of_requests,     :type => Integer, :default => 0
  field :max_num_of_requests, :type => Integer, :default => 100000

  validates :secret_id,    :presence => true, :uniqueness => true
  validates :secret_token, :presence => true, :uniqueness => true
  validates :email,        :presence => true

  attr_readonly :created_at
  attr_accessible :email

  scope :by_id,           lambda{ |id| where(:id => id) }
  scope :by_secret_id,    lambda{ |s_id| where(:secret_id => s_id) }
  scope :by_secret_token, lambda{ |s_t| where(:secret_token => s_t) }
  scope :active,          where(:active => true)

  before_validation do
    if new_record?
      generate_secret_id
      generate_secret_token
    end
  end

  def self.auth?(app_secret_id, app_secret_token)
    self.by_secret_id(app_secret_id).by_secret_token(app_secret_token).active.exists?
  end

  def self.find_by_auth(app_secret_id, app_secret_token)
    self.by_secret_id(app_secret_id).by_secret_token(app_secret_token).active.first
  end

  def add_request!
    self.num_of_requests += 1
    self.active = false if self.num_of_requests >= max_num_of_requests
    save!
  end

  def remaining_requests
    max_num_of_requests - num_of_requests
  end

  private

  def generate_secret_id
    generated_id = SecureRandom.hex(25)
    if Application.by_secret_id(generated_id).exists?
      generate_secret_id
    else
      self.secret_id = generated_id
    end
  end

  def generate_secret_token
    generated_token = SecureRandom.base64(25)
    if Application.by_secret_token(generated_token).exists?
      generate_secret_token
    else
      self.secret_token = generated_token
    end
  end
end