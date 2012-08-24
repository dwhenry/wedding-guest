class GuestPermission < ActiveRecord::Base
  belongs_to :user
  belongs_to :guest
  belongs_to :list, :class_name => 'GuestOwner'

  scope :for_wedding, lambda {|wedding|
    includes(:guest).where(['guests.wedding_id = ?', wedding.id])
  }
  scope :with_list, where('guest_permissions.list_id is not null')

  validates_uniqueness_of :user_id, :scope => :guest_id
  validates_uniqueness_of :guest_id, :scope => :user_id
end