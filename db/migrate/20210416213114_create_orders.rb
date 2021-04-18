class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :orderType
      t.string :orderFrom
      t.string :menuImage
      t.string :status
      t.references :user
      t.timestamps
    end
    add_foreign_key :orders, :users, column: :user_id, primary_key: :id

  end
end
