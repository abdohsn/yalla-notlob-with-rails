class CreateOrderDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :order_details do |t|
      t.string :item_name
      t.integer :amount
      t.float :price
      t.text :comment
      t.references :user_order_join
      t.timestamps
    end
    add_foreign_key :order_details, :user_order_joins, column: :user_order_join_id, primary_key: :id
  end
end
