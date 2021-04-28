class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  has_many :ownedOrders, :class_name => "Order", :foreign_key => 'user_id'
  has_many :user_order_joins
  has_many :orders, through: :user_order_joins
  has_many :orders
  has_many :user_order_joins
  has_many :order_details
  has_one_attached :avatar
  after_commit :add_default_avatar, on: %i[create]

  has_many :friendships, :dependent => :delete_all
  has_many :friends, :through => :friendships
  has_many :groups, :dependent => :delete_all
  has_many :group_members, :dependent => :delete_all

  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable,

         # Add omniauthable and pass in which ever providers you are using here.
        #  :omniauthable, omniauth_providers:[:facebook, :github, :google_oauth2]
 
  devise :database_authenticatable,
         :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook, :github, :google_oauth2]
# Step Fifteen:
# Create and assign providers into table

  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
      puts "AAAAAAAAAAAAAAAAAAAAAAAAA"
      puts provider_data.info.inspect
      puts "xxxxxAAAAAAAAAAAAAAAAAAAAAAA"
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
      user.image=provider_data.info.image
      user.full_name=provider_data.info.name
      # user.avatar="http://graph.facebook.com/v4.0/1181831935610417/picture?access_token=EAAaDL1IMjy0BAMRWdS2ZBP6UZBuN0QUalLCp2AkW4i8zLxzEHRZCbWrmj5WVRdgBIS1dGMmbVlRZApxtTn3tTTpdWXwwAMRrTaDp7r7ZCp9Qpa7Eu4yCZA0Ov0KZAU03DYBmqOzoQn0NZCRz5NvIRgOHYiX4xFcZBkoLsPbxRfhZBSNAZDZD"
      # puts "IMAGEEEEEEEEEEEE"
      # puts String(provider_data.image)
      # puts "IMAGEEEEEEEEEEEE"
    end
  end



  # def self.connect_to_gmail(auth, signed_in_resource=nil)
  #   puts "------>>>>>" 
  #   puts auth.info
  #   puts "------<<<<<" 
  #   user = User.where(:provider => auth.provider, :uid => auth.uid).first
  #   if user
  #     return user
  #   else
  #     registered_user = User.where(:email => auth.info.email).first
  #     if registered_user
  #       return registered_user
  #     else
  #       user = User.create(
          
  #         provider:auth.provider, uid:auth.uid, email:auth.info.email,
  #         password:Devise.friendly_token[0,20],
  #       )
  #     end
  #   end
  # end

  

  # def avatar_from_provider

  def avatar_thumbnail
    if avatar.attached?
    avatar.variant(resize: "50x50!").processed
    elsif user.image?
      user.image 
      puts "TOTOTOTOTOTOTOTOTOO"
      puts user.image
      puts "TOTOTOTOTOTOOTTOOTT"
    else
      "/default_profile.jpg"
    end
  end

  private
  def add_default_avatar
    unless avatar.attached?
      avatar.attach(
        io: File.open(
          Rails.root.join(
            'app', 'assets', 'images', 'default_profile.jpg'
          )
        ),
        filename: 'default_profile.jpg',
        content_type: 'image/jpg'
      )
    end
  end

end
