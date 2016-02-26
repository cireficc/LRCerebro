class Lab < ActiveRecord::Base
    self.abstract_class = true
  
    # Lab locations
    # :a - Lab A (the lab with the main doors)
    # :b - Lab B (the lab in the middle)
    # :c - Lab C (the smallest lab in the back)
    # :c_a - Lab C/A (the students are split between Lab C and Lab A)
    enum location: [:a, :b, :c, :c_a]
    
    # The total number of student workstations in each lab
    WORKSTATIONS = {
        a: 20,
        b: 30,
        c: 16,
        c_a: 36
    }
end