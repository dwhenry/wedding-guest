class Wedding < ActiveRecord::Base
  mount_uploader :image, BrideGroomUploader
  default_scope :order => 'name'

  has_many :guests

  validates_presence_of :name
  validates_presence_of :on
  validates_presence_of :bride
  validates_presence_of :groom

  def details
    {
      :wedding => name,
      :date => on,
      :image_path => image.thumb.url
    }
  end
end
