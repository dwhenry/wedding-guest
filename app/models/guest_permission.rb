class GuestPermission < ActiveRecord::Base
  belongs_to :user
  belongs_to :guest
  belongs_to :list, :class_name => 'GuestOwner'

  scope :for_wedding, lambda {|wedding|
    includes(:guest).where(['guests.wedding_id = ?', wedding.id])
  }

  scope :with_list, where('guest_permissions.list_id is not null')
end