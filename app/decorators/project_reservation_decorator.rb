class ProjectReservationDecorator < Draper::Decorator
  delegate_all

  SUBTYPES_SHORTHAND = {
      project_introduction: "ProjIntro",
      camera_training: "VidCam",
      camtasia_training: "Camtas.",
      in_class_shoot: "In-cl Shoot"
  }
  
  def subtype_shorthand
    SUBTYPES_SHORTHAND[subtype.to_sym]
  end
  
  def short_date(date)
    date.to_s[10..-1]
  end

end
