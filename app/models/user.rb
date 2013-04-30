class User < OmniAuth::Identity::Models::ActiveRecord
  attr_accessible :avatar, :birthday, :city, :constellation, :dribbble, :email, :github, :graduation, :jointime, :name, :nick, :phonecall, :qq, :role, :slogan, :twitter, :website, :weibo, :weixin,:password, :password_confirmation,:custom_status_comment
  has_many :logs
  has_many :authentications
  has_many :totals



  auth_key :email
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, :presence => true,
            :format     => { :with => email_regex },
            :uniqueness => { :case_sensitive => false }

  def self.create_with_omniauth(auth)
    # you should handle here different providers data
    # eg. case auth['provider'] ..
    auth_has_an_nick = auth['info']['nickname'] ||= auth['provider']+auth['uid']
    auth_has_an_email = auth['info']['email'] ||= auth['provider']+auth['uid']+'@'+'mail.com'

    temp_password = rand(36**10).to_s(36) 
    create(name: auth_has_an_nick, email: auth_has_an_email, password:temp_password, password_confirmation:temp_password)
    # IMPORTANT: when you're creating a user from a strategy that
    # is not identity, you need to set a password, otherwise it will fail
    # I use: user.password = rand(36**10).to_s(36)
  end

  def admin?
    self.email == "linsk@linsk.cn"
  end

  def nick_or_name
    self.nick ||= self.name
  end

  def name_or_nick
    self.name ||= self.nick
  end

  def status #TODO为新注册用户初始化一个log记录。
    self.logs.create(:where => "online") unless self.logs.last.updated_at
    self.logs.last.updated_at > Time.now - FRESH_TIME ? self.logs.last.where : "offline"
  end

  def status_comment
    self.custom_status_comment || self.status_comments
  end

  def status_comments
    case self.status
    when "office"
      #今天几点就来到办公室的...
      "bla bla"
    when "online"
      #今天上线几个小时了...
      "always online"
    else
      self.leaved
    end
  end

  def leaved
    p = "leave "
    t = Time.now - self.logs.last.updated_at 
    if t > 86400
      d = t / 86400
      p + d.to_i.to_s + " day ago."
    elsif t >3600
      h = t / 3600
      p + h.to_i.to_s + "hour ago."
    else
      t > 60 ? m = t/60 : m=1
      p + m.to_i.to_s+" min ago."
    end
  end
end
