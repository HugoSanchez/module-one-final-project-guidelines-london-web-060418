class User < ActiveRecord::Base
  has_many :viewings
  has_many :listings, through: :viewings
end
