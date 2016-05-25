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
end