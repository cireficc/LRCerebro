class Project < ActiveRecord::Base
    
    belongs_to :course
    
    # Project categories
    # :camtasia - A video project using Camtasia Studio
    # :garage_band - A podcast-type project using Garage Band
    # :pixton - A comic book project using Pixton
    # :photo_booth - A short video or photo project using Photo Booth
    # :blog - A blog project using Google Sites
    # :pages - A document-based project using Pages
    # :other - A different type of project that should be detailed in the project's description
    enum category: [:camtasia, :garage_band, :pixton, :photo_booth, :blog, :pages, :other]
end
