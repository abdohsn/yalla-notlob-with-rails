class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  has_many :ownedOrders, :class_name => "Order", :foreign_key => 'user_id'
  has_many :user_order_joins
  has_many :orders, through: :user_order_joins
  has_many :orders
  has_many :user_order_joins
  has_many :order_details

  has_many :friendships, :dependent => :delete_all
  has_many :friends, :through => :friendships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers:[:facebook]
  
  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
