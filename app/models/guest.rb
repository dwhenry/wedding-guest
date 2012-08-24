class Guest < ActiveRecord::Base
  belongs_to :wedding
  belongs_to :owner, :class_name => 'GuestOwner', :foreign_key => 'guest_owner_id'
  has_many :permissions, :class_name => 'GuestPermission'

  scope :for, lambda {|owner_name|
    includes(:owner).where(guest_owners: {name: owner_name})
  }

  before_create :make_pending
  validates_uniqueness_of :name, :email, :phone, :scope => :wedding_id

  def make_pending
    self.status = 'Pending'
  end

  def confirm!
    update_attributes!(:status => 'Confirmed')
  end

  def contact=(value)
    value =~ /@/ ? (self.email = value) : (self.phone = value)
  end

  def contact
    email || phone
  end

  def owner=(guest_owner)
    if guest_owner.is_a? GuestOwner
      guest_owner_id = guest_owner.id
    else
      guest_owner_id = GuestOwner.find_by_name!(guest_owner).id
    end
  end

  class Permissions < SimpleDelegator
    def ensure_permissions_for(user)
      permission = permissions.where(:user_id => id).first
      if permission
        if permission.list != list
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
