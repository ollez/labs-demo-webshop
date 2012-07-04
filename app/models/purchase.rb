class Purchase < ActiveRecord::Base
  belongs_to :product
  attr_accessible :quantity, :product_id


  def order_id
    1000 + id
  end
end
