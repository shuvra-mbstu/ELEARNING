module ContentType
  extend ActiveSupport::Concern

  VIDEO_TYPE = %i(video/mov video/mp4)

  included do
    validates :video_tutorial, content_type: IMAGE_TYPE
  end
end