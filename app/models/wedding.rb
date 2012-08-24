require 'fields'
class Wedding < ActiveRecord::Base
  extend Fields
  formatted_date :on
  mount_uploader :image, BrideGroomUploader
  default_scope :order => 'weddings.name'

  has_many :guests
  has_many :guest_owners

  validates_presence_of :name, :on, :bride, :groom, :bride_email, :groom_email

  after_create :create_guest_owner_list

  def create_guest_owner_list
    all_guests = self.guest_owners.create!(:name => 'All')
    bride_list = self.guest_owners.create!(:name => 'Bride')
    groom_list = self.guest_owners.create!(:name => 'Groom')

    create_guest(all_guests, bride, bride_email, bride_list)
    create_guest(all_guests, groom, groom_email, groom_list)
  end

  def details
    {
      :wedding => name,
      :date => on,
      :image_path => image.thumb.url
    }
  end

private

  def create_guest(owner, name, email, list)
    created_guest = owner.guests.create!(
      :name => name,
      :email => email,
      :seats => 1,
      :wedding => self
    )

    if user = User.find_by_email(email)
      created_guest.permissions.create(:user => user, :list => list)
    end

    created_guest.confirm!
  end

  class List < SimpleDelegator
    def for(email)
      if groom_email == email
        groom_list
      elsif bride_email == email
        bride_list
      end
    end

    def groom_list
      guest_owners.where(:name => 'Groom').first
    end

    def bride_list
      guest_owners.where(:name => 'Bride').first
    end
  end

end
