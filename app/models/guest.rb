class Guest < ActiveRecord::Base
  belongs_to :wedding
  belongs_to :owner, :class_name => 'GuestOwner', :foreign_key => 'guest_owner_id'
  has_many :permissions, :class_name => 'GuestPermission'

  scope :for, lambda {|owner_name|
    includes(:owner).where(guest_owners: {name: owner_name})
  }

  after_create :make_pending

  def make_pending
    self.status = 'Pending'
  end

  def confirm!
    update_attributes!(:status => 'confirmed')
  end

  def contact=(value)
    value =~ /@/ ? (self.email = value) : (self.phone = value)
  end

  def contact
    email || phone
  end

  def owner=(value)
    if value.is_a? GuestOwner
      super
    else
      owner = GuestOwner.find_by_name!(value)
    end
  end
end
