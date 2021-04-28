class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.text :body
      t.text :notificationType
      t.boolean :seen
      t.references :user

      t.timestamps
    end
    add_foreign_key :notifications, :users, column: :user_id, primary_key: :id
  end
end
