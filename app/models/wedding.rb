class Wedding < ActiveRecord::Base
  mount_uploader :image, BrideGroomUploader
  default_scope :order => 'name'

  has_many :guests

  def details
    {
      :wedding => name,
      :date => on,
      :image_path => image.thumb.url
    }
  end
end
