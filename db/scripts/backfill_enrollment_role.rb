Enrollment.all.each do |e|
  if e.user.student?
    e.role = Enrollment.roles[:student]
  else
    e.role = Enrollment.roles[:instructor]
  end
  e.save
end