class Product < ActiveRecord::Base
  has_many :purchases
  attr_accessible :description, :name, :price
end
