class Wedding < ActiveRecord::Base
  mount_uploader :image, BrideGroomUploader

  def details
    {
      :wedding => name,
      :date => on,
      :image_path => image.thumb.url
    }
  end
end
