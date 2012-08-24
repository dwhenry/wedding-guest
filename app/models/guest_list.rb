class GuestList < ActiveRecord::Base
  belongs_to :wedding
  has_many :guests
  has_many :permissions, :class_name => 'GuestPermission', :foreign_key => 'list_id'
  has_many :users, :through => :permissions

  def users=(nick_name)
    user_id = User.find_by_nickname(nick_name)
    if user_id && permission = permissions.where(user_id: user_id).first
      permission.update_attributes!(:list => self)
    end
  end
end
