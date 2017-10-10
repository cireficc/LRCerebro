class ProjectReservationDecorator < Draper::Decorator
  delegate_all

  SUBTYPES_SHORTHAND = {
    project_introduction: 'ProjIntro',
    script_writing: 'ScriptWrite',
    camera_training: 'VidCam',
    camtasia_training: 'Camtas.',
    in_class_shoot: 'In-cl Shoot',
    in_class_editing: 'In-cl Edit',
    screen_final_project: 'ScreenProj'
  }.freeze

  def subtype_shorthand
    SUBTYPES_SHORTHAND[subtype.to_sym]
  end

  def short_date(date)
    date.to_s[10..-1]
  end
end
