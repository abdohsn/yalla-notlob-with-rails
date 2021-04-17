class CreateUserOrderJoins < ActiveRecord::Migration[6.1]
  def change
    create_table :user_order_joins do |t|
      t.belongs_to :order
      t.timestamps
    end
    add_foreign_key :user_order_joins, :orders, column:  :order_id, primary_key: :id
  end
end
