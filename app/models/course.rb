class Course < ActiveRecord::Base
    
    has_and_belongs_to_many :users
    has_many :projects
    
    # Enum to describe the semester in which a course takes place.
    # Although there are technically 3 summer semester types
    # (6-week 1, 6-week 2, 12-week), classify them all as summer
    # because that's way easier, and it doesn't really make a difference.
    enum semester: [:fall, :winter, :summer]
    
    # Enum to describe the MLL department to which the course belongs.
    # Basically, each language has its own department.
    enum department: [:arabic, :chinese, :french, :german, :italian, :japanese, :russian, :spanish, :lrc]
end
