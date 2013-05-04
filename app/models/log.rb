class Log < ActiveRecord::Base
  attr_accessible :where_online,:device
  belongs_to :user
end
