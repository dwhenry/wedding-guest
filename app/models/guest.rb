class Guest < ActiveRecord::Base
  belongs_to :wedding
  belongs_to :list, :class_name => 'GuestList', :foreign_key => 'guest_list_id'
  has_many :permissions, :class_name => 'GuestPermission'
  has_many :users, :through => :permissions

  scope :for, lambda {|owner_name|
    includes(:list).where(guest_lists: {name: owner_name})
  }

  before_create :make_pending
  validates_uniqueness_of :name, :scope => :wedding_id
  validates_uniqueness_of :email, :scope => :wedding_id, :unless => lambda {|a| a.email.blank? }
  validates_uniqueness_of :phone, :scope => :wedding_id, :unless => lambda {|a| a.phone.blank? }
  validates_presence_of :wedding_id, :guest_list_id

  def make_pending
    self.status = 'Pending'
  end

  def confirm!
    update_attributes!(:status => 'Confirmed')
  end

  def confirmed?
    status == 'Confirmed'
  end

  def contact=(value)
    value =~ /@/ ? (self.email = value) : (self.phone = value)
  end

  def contact
    email || phone
  end

  def list=(guest_list)
    if guest_list.is_a? GuestList
      self.guest_list_id = guest_list.id
    else
      self.guest_list_id = GuestList.find_by_name!(guest_list).id
    end
  end

  class Permissions < SimpleDelegator
    def ensure_permissions_for(user)
      permission = permissions.where(:user_id => user.id).first
      if permission
        if permission.list != list && !list.nil?
          permission.update_attributes!(:list => list)
        end
      else
        permissions.create!(:user => user, :list => list)
      end
    end

    def list
      @list ||= Wedding::List.new(wedding).for(email)
    end
  end
end
