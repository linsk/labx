class Log < ActiveRecord::Base
  attr_accessible :where,:device
  belongs_to :user
end
