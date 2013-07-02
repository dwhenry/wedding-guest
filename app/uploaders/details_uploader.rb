# encoding: utf-8

class DetailsUploader < CarrierWave::Uploader::Base

  if Rails.env.production?
    include Cloudinary::CarrierWave

    def rotate!(angle)
      cloudinary_transformation :transformation => [
        {:angle => angle}
      ]
    end
  else
    include CarrierWave::RMagick
    # Include RMagick or MiniMagick support:
    include CarrierWave::RMagick
    # include CarrierWave::MiniMagick

    # Choose what kind of storage to use for this uploader:
    storage :file
    # storage :fog

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    def cache_dir
      "#{Rails.root}/tmp/uploads"
    end

    process :auto_orient

    def auto_orient
      manipulate! do |img|
        img = img.auto_orient
      end
    end

    def rotate!(angle)
      manipulate! do |img|
        img.rotate!(angle)
        img
      end
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  process :resize_to_fit => [150, 150]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [40, 40]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
