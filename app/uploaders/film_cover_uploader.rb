class FilmCoverUploader < CarrierWave::Uploader::Base

  # # LOCAL with ImageMagick
  # include CarrierWave::MiniMagick

  # storage :file

  # def store_dir
  #   "uploads/#{model.class.to_s.underscore}"
  # end

  # # Smaller size for show action
  # version :display do
  #   process :resize_to_fit => [400, 600]
  # end

  # # Smallest size for index action
  # version :thumb do
  #   process :resize_to_fit => [100, 150]
  # end

  # def filename
  #   "#{model.transliterated_foreign_title}.#{file.extension}"
  # end



  # CLOUDINARY
  include Cloudinary::CarrierWave

  # If we're in development, add a tag so we can easily delete dev images later
  process :tags => ["development"] if (ENV["RAILS_ENV"] == "development" || ApplicationController::SEEDING_IN_PROGRESS)

  version :display do
    eager
    resize_to_fit(400, 600)
  end

  version :thumb do
    eager
    resize_to_fit(100, 150)
  end

  def public_id
    model.transliterated_foreign_title
  end
end
