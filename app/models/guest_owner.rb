class GuestOwner < ActiveRecord::Base
  belongs_to :wedding
  has_many :guests
  has_many :permissions, :class_name => 'GuestPermission', :foreign_key => 'list_id'
  has_many :users, :through => :permissions
end
