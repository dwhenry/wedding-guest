require 'fields'
class Wedding < ActiveRecord::Base
  extend Fields
  formatted_date :on
  mount_uploader :image, BrideGroomUploader
  default_scope :order => 'name'

  has_many :guests
  has_many :guest_owners

  validates_presence_of :name
  validates_presence_of :on
  validates_presence_of :bride
  validates_presence_of :groom

  after_create :create_guest_owner_list

  def create_guest_owner_list
    self.guest_owners.create!(:name => 'All')
    self.guest_owners.create!(:name => 'Bride')
    self.guest_owners.create!(:name => 'Groom')
  end

  def details
    {
      :wedding => name,
      :date => on,
      :image_path => image.thumb.url
    }
  end
end
