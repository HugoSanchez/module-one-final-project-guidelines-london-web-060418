class Listing < ActiveRecord::Base
  has_many :viewings
  has_many :users, through: :viewings
end
