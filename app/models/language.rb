class Language < ActiveRecord::Base
  self.abstract_class = true

  LANGUAGES = %w(
        Arabic
        Chinese
        English
        French
        German
        Italian
        Japanese
        Russian
        Spanish
    )
end