class UserOrderJoin < ApplicationRecord
    belongs_to :order
    has_many :order_detail
end
