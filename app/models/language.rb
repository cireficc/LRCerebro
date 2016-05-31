class Language < ActiveRecord::Base
    self.abstract_class = true
  
    enum language: {
        arabic: 0,
        chinese: 1,
        english: 2,
        french: 3,
        german: 4,
        italian: 5,
        japanese: 6,
        russian: 7,
        spanish: 8,
        other: 9
    }
    
    # Pass in a field (value) and the field name to validate the language enum across multiple models
    # Return the error message to the caller to use with errors.add
    def self.validate_languages(field)
        
        # This is not the greatest idea, but it works. Remove the empty string during validation
        field.reject! { |l| l.empty? }
        
        if !field.any?
            return "need to select a language"
        end
        
        # If any of the audio languages is invalid, add the error and break
        field.each do |f|
            valid = false
            Language.languages.each do |l, i|
                valid = true if (f.downcase == l.downcase)
            end
            
            return "not a valid language selection" unless valid
        end
    end
end