class Total < ActiveRecord::Base
  belongs_to :user
  attr_accessible :counter, :end, :start
end
