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
end
