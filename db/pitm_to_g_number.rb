mll_data_directory = Rails.root.join('db', 'MLL_data')
pitm_g = mll_data_directory.join('pitm_g.txt')

log_file_path = mll_data_directory.join('pitm_g_log.txt')

require 'csv'

log_file = File.open(log_file_path, "w")
log_file.puts "Log file for attempted G# --> PITM migration on #{Time.current.to_s}\n\n"

# Iterate through all of the MLL faculty/students
CSV.foreach(pitm_g, col_sep: '|', headers: false).each_with_index do |row, i|

  # Format: g_number|pitm
  # e.g. G00000000|1234567890

  g_number = row[0].downcase
  pitm = row[1]

  @user = User.find_by(g_number: g_number)
  @enrollment = Enrollment.where(user_id: g_number)

  if @user
    log_file.puts "Replacing #{@user.last_name}, #{@user.first_name} (#{@user.g_number}) with #{pitm}"

    @user.g_number = pitm
    @user.save
  end

  @enrollment.each do |e|
    log_file.puts " - Replacing enrollment for course #{e.course_id}"
    e.user_id = pitm
    e.save
  end
end

log_file.puts "\n\nNot replaced: \n\n"

@not_replaced = User.where("g_number LIKE 'g%'")

@not_replaced.each do |user|
  log_file.puts "#{user.last_name}, #{user.first_name} (#{user.g_number})"
end
