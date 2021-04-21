class Group < ApplicationRecord
    belongs_to :user
    has_many :group_members, :dependent => :delete_all
end


  