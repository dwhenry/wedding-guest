class GuestList < ActiveRecord::Base
  belongs_to :wedding
  has_many :guests
  has_many :permissions, :class_name => 'GuestPermission', :foreign_key => 'list_id'
  has_many :users, :through => :permissions

  attr_accessor :description

  def user_id

  end

  def user_id=(user_id)

  end
end
