class UserOrderJoin < ApplicationRecord
    belongs_to :user
    belongs_to :order
    has_many :order_detail
end
