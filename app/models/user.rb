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
    self.email == "sk@mothin.com"
  end

  def nick_or_name
    self.nick ||= self.name
  end

  def name_or_nick
    self.name ||= self.nick
  end

  def status
    @pre_log = self.logs.last
    @pre_log.updated_at + self.fresh_time > Time.now ? @pre_log.where_online : "offline"
  end


  def recodes_init  #model调用controller的方法 
    self.logs.create(:where_online => "online",:device => "Windows")
    self.totals.create(:start => Time.now)
  end

  def status_comments
 
    if self.status == "offline"
      #今天来过否?
      self.came
    else
      self.totalset(self.status)
    end

  end

  def totalset(office_online)#*args
    #tt = Time.now.midnight if timetype == "day"  #按 日 周 月 年 查询
    from_today = Time.now.midnight.in_time_zone('Beijing')
    officetime = self.totals.where("start > ? AND where_online = ?", from_today, office_online) 
    office_now = self.logs.where("where_online=? AND updated_at>?",office_online,from_today).first
    lastoday = self.logs.where("where_online=? AND updated_at>?",office_online,from_today).last

    if officetime != []
      start_at = officetime.first.start.in_time_zone('Beijing').to_s(:time)
      timesum = officetime.sum("counter").to_s.to_f 
      timesum =timesum+(lastoday.updated_at - officetime.last.start)#未汇计的部分时间
    elsif office_now
      start_at = office_now.updated_at.in_time_zone('Beijing').to_s(:time)
      timesum = Time.now - office_now.updated_at
    else
      timesum = nil#没有今天的记录
    end
    timesum = longtime(timesum) if timesum
    "Start from %s, %s total time: %s " % [start_at,office_online,timesum] if timesum
  end

  def came
    office_online = "office" 
    from_today = Time.now.midnight.in_time_zone('Beijing')
    officetime = self.totals.where("start > ? AND where_online = ?",from_today, office_online)
    lastoday = self.logs.where("where_online=? AND updated_at>?",office_online,from_today).last

    if officetime != []
      start_at = officetime.first.start.in_time_zone('Beijing').to_s(:time)
      timesum = officetime.sum("counter").to_s.to_f
      timesum =timesum+(lastoday.updated_at - officetime.last.start)
    elsif lastoday
      firstoday = self.logs.where("where_online=? AND updated_at>?",office_online,from_today).first
      start_at = firstoday.updated_at.in_time_zone('Beijing').to_s(:time)
      timesum = lastoday.updated_at - firstoday.updated_at
    else
      timesum = nil #Did not come today
    end
    timesum = longtime(timesum)  if timesum
    "Came from %s, %s total time: %s " % [start_at,office_online,timesum] if timesum
  end

  def leaved
    p = "leave "
    officelast = self.logs.where("where_online=?",'office').last
    if officelast
      t = Time.now - officelast.updated_at
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

  def longtime(t)
    t=t.to_i
    ds = t > 86400 ? time % 86400 : t
    hs = ds > 3600 ? ds % 3600 : ds
    
    d = t / 86400
    h = ds/3600
    m = hs/60
     "%s hours %s minutes" % [h,m]
  end

  def fresh_time
    self ? FRESH_TIME : OTHER_TEAM_REFRESH_TIME  #self.team_id = 1 #120s and 600s
  end

end
