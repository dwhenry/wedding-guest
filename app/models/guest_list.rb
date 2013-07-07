class GuestList < ActiveRecord::Base
  belongs_to :wedding
  has_many :guests
  has_many :permissions, :class_name => 'GuestPermission', :foreign_key => 'list_id'
  has_many :users, :through => :permissions

  scope :for, ->(user) do
    if user
      includes(:permissions).
      where(["guest_permissions.user_id = ? or guest_lists.name = 'All'", user.id])
    else
      current_scope
    end
  end

  def user=(nick_name)
    user = User.find_by_nickname(nick_name)
    if user && permission = user.permissions.for_wedding(wedding).first
      permission.update_attributes!(:list => self)
    end
  end

  def remove_user_permissions(user_id)
    if permission = permissions.where(user_id: user_id).first
      permission.update_attributes!(:list => nil)
    end
  end
end
