class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :resize_to_fill => [300, 300]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process :resize_to_fill => [50, 50]
  end
end
