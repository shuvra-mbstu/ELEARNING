class VideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # include CarrierWave::RMagick
  include CarrierWave::Video
  # include CarrierWave::FFmpeg
  include CarrierWave::Video::Thumbnailer
  
  storage :file
  
  # def store_dir
  #   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end
  
  version :thumb do
    process thumbnail: [{format: 'png', quality: 10, size: 192, strip: true, logger: Rails.logger}]
    
    def full_filename for_file
      png_name for_file, version_name
    end
  end

  version :small_thumb, from_version: :thumb do
    process resize_to_fill: [20, 200]
  end

  version :medium_thumb, from_version: :thumb do
    process resize_to_fill: [20, 200]
  end
  
  def png_name for_file, version_name
    %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.png}
  end
end
