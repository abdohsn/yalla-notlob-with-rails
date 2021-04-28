class CreateUserOrderJoins < ActiveRecord::Migration[6.1]
  def change
    create_table :user_order_joins do |t|
      t.belongs_to :user
      t.belongs_to :order
      t.timestamps
    end
    add_foreign_key :user_order_joins, :users, column: :user_id, primary_key: :id
    add_foreign_key :user_order_joins, :orders, column:  :order_id, primary_key: :id ,on_delete: :cascade
  end
end
