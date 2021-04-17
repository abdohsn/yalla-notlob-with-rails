class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :orderType
      t.string :orderFrom
      t.string :menuImage
      t.string :status
      t.timestamps
    end
  end
end
