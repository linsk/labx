class Log < ActiveRecord::Base
  attr_accessible :where
  belongs_to :user
end
