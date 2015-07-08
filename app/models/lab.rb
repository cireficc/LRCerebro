class Lab < ActiveRecord::Base
    self.abstract_class = true
  
    # Lab locations
    # :a - Lab A (the lab with the main doors)
    # :b - Lab B (the lab in the middle)
    # :c - Lab C (the smallest lab in the back)
    enum location: [:a, :b, :c]
    
    # The total number of student workstations in each lab
    WORKSTATIONS = {
        a: 20,
        b: 30,
        c: 16
    }
end