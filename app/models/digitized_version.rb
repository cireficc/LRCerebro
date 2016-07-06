class DigitizedVersion < ActiveRecord::Base
    
    belongs_to :film
    
    validates :audio_language, :subtitle_language, :direct_link, :embed_code, presence: true
end
