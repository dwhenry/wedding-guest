class Wedding < ActiveRecord::Base
  mount_uploader :image, BrideGroomUploader
end
