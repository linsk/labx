class User < OmniAuth::Identity::Models::ActiveRecord
  attr_accessible :avatar, :birthday, :city, :constellation, :dribbble, :email, :github, :graduation, :jointime, :name, :nick, :phonecall, :qq, :role, :slogan, :twitter, :website, :weibo, :weixin,:password, :password_confirmation
  has_many :logs
  has_many :authentications


  auth_key :email
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, :presence => true,
            :format     => { :with => email_regex },
            :uniqueness => { :case_sensitive => false }

  def self.create_with_omniauth(auth)
    # you should handle here different providers data
    # eg. case auth['provider'] ..
    auth_has_an_email = auth['info']['email'] ||= auth['provider']+auth['uid']+'@'+'mail.com'
    temp_password = rand(36**10).to_s(36) 
    create(name: auth['info']['name'],email: auth_has_an_email, temppasswd: temp_password, password: temp_password)
    # IMPORTANT: when you're creating a user from a strategy that
    # is not identity, you need to set a password, otherwise it will fail
    # I use: user.password = rand(36**10).to_s(36)
  end

  def admin?
    self.email == "linsk@linsk.cn"
  end

  def status
    if self.logs.last.created_at > Time.now - FRESH_TIME #60s?
      self.logs.last.where
    else
      status = "offline"
    end
  end

  def leaved
    p = "leavad ago"
    t = Time.now - self.logs.last.created_at
    if t > 86400
      d = t / 86400
      p + d.to_i.to_s + " day"
    elsif t >3600
      h = t / 3600
      p + h.to_i.to_s + "hour"
    else
      t > 60 ? m = t/60 : m=1
      p + m.to_i.to_s+" min."
    end
  end
end
