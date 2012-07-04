class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :product
      t.integer :quantity

      t.timestamps
    end
    add_index :purchases, :product_id
  end
end
