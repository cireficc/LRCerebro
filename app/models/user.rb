class User < ActiveRecord::Base
    
    has_and_belongs_to_many :courses
    
    # User roles in the MLL department and the LRC:
    # :director - Director and assistant director of the LRC. Highest privileges
    # :labasst - Lab assistants of the LRC. Elevated privileges
    # :faculty - Faculty in the MLL department who teach courses
    # :student - Students in the MLL department who enroll in courses
    enum role: [:director, :labasst, :faculty, :student]
    
    has_secure_password
end
