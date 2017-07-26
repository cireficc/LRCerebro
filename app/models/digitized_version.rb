class DigitizedVersion < ActiveRecord::Base

  belongs_to :film

  validates :audio_language, presence: true
end
