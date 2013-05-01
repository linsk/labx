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
    auth_has_an_nick = auth['info']['nickname'] ||= auth['provider'] + auth['uid'].to_s
    auth_has_an_email = auth['info']['email'] ||= auth['provider'] + auth['uid'].to_s + '@' + 'mail.com'
    avatar_image = auth[:info][:image] ||= []
    temp_password = rand(36**10).to_s(36) 
    create(name: auth_has_an_nick, email: auth_has_an_email, avatar: avatar_image, password:temp_password, password_confirmation:temp_password)
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
    self.logs.create(:where => "online") if self.logs == []
    self.logs.last.updated_at > Time.now - FRESH_TIME ? self.logs.last.where : "offline"
  end

  # def status_comment
  #   self.custom_status_comment || self.status_comments
  # end

  def status_comments
    # case self.status
    # when "office"
    #   #今天几点就来到办公室的... 总共时间totals中的时间+（最后一个Time.now-start）.格式化时间长度？
    #    self.totalset("office")
    # when "online"
    #   #今天上线几个小时了...
    #   #"always online"
    #   self.totalset("online")
    # else
    #   self.leaved
    # end
    if self.status == "offline"
      #今天来过否?
      self.came
    else
      self.totalset(self.status)
    end

  end

  def totalset(office_online)#*args
    #tt = Time.now.midnight if timetype == "day"  #按 日 周 月 年 查询
    officetime = Total.where("start > ? AND where_online = ? AND user_id=?", Time.now.midnight, office_online, self.id) 
    ""
    if officetime != []
      start_at = officetime.first.start.in_time_zone('Beijing').to_s(:time)
      timesum = officetime.sum("counter").to_s.to_f 
      timesum =timesum+(Time.now - officetime.last.start)#未汇计的部分时间
      timesum = longtime(timesum)
      "Start from %s, %s total time: %s " % [start_at,office_online,timesum]
    end
  end

  def came
    office_online = "office" 
    officetime = Total.where("start > ? AND where_online = ? AND user_id=?", Time.now.midnight, office_online, self.id)
    if officetime == []
      ""#Did not come today
    else
      start_at = officetime.first.start.in_time_zone('Beijing').to_s(:time)
      timesum = officetime.sum("counter").to_s.to_f
      timesum =timesum+(Time.now - officetime.last.start)
      timesum = longtime(timesum)
      "Came from %s, %s total time: %s " % [start_at,office_online,timesum]
    end
  end

  def leaved
    p = "leave "
    t = Time.now - self.logs.last.updated_at #TODO 离开办公室
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
  def longtime(t)
    t=t.to_i
    ds = t > 86400 ? time % 86400 : t
    hs = ds > 3600 ? ds % 3600 : ds
    
    d = t / 86400
    h = ds/3600
    m = hs/60
     "%s hours %s minutes" % [h,m]
  end
end
