class Order < ApplicationRecord
    belongs_to :user, :class_name => "User",:optional => true
    has_many :user_order_joins    
    has_many :users, through: :user_order_joins  , dependent: :delete_all

end
