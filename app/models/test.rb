class Test < ActiveRecord::Base
  
  STRING_ENUM_OPTIONS = %w(
      Camtasia
      GarageBand
      Pixton
      PhotoBooth
      StoryBird
      Blog
      Pages
  )
  
  validates :string_enum, presence: true
end
