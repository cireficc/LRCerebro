module ApplicationHelper

  LOCAL_TIME_ZONE = "America/Detroit"

  def info_popover(partial_path, title)
    content = render("partials/popovers/#{partial_path}")
    a = link_to("", "#", class: 'glyphicon glyphicon-info-sign', data: { content: content, original_title: title, toggle: "popover" }, role: "button", tabindex: "-1")
    # Remove href="#" so that clicking a popover doesn't take the user to the top of the page
    a.sub('href="#"', "").html_safe
  end

  def generate_403_email_body
    u = current_user
    body = "\n\n---------- Please do not remove or modify the information below this line ----------\n\n"
    body += (sprintf "%-15s %s\n", "First name:", u.first_name)
    body += (sprintf "%-15s %s\n", "Last name:", u.last_name)
    body += (sprintf "%-15s %s\n", "Username:", u.username)
    body += (sprintf "%-15s %s\n", "Role:", u.role)
    body += (sprintf "%-15s %s\n", "URL:", request.url)
  end

  def last_page
    session[:last_page]
  end

  def self.local_to_utc(time)
    ActiveSupport::TimeZone.new(LOCAL_TIME_ZONE).local_to_utc(time)
  end

  def self.utc_to_local(time)
    ActiveSupport::TimeZone.new(LOCAL_TIME_ZONE).utc_to_local(time)
  end
  
  # If doing a site-wide search, hide resource-specific search fields
  def search_performed?
    params[:utf8].present? && !controller_name.eql?('search')
  end
  
  def site_wide_search?
    controller_name.eql? 'search'
  end
  
  def form_submission_allowed?
    # The date in the database is in UTC, but this is in local time. So we need to make sure they are both in UTC otherwise
    # the date comparisons are off by whatever the difference is between local time and UTC
    now = Time.now.asctime.in_time_zone('UTC')
    now >= @application_configuration.current_semester_start && now <= @application_configuration.current_semester_end
  end
  
  def project_submission_allowed?
    # The date in the database is in UTC, but this is in local time. So we need to make sure they are both in UTC otherwise
    # the date comparisons are off by whatever the difference is between local time and UTC
    now = Time.now.asctime.in_time_zone('UTC')
    now >= @application_configuration.class_project_submission_start && now <= @application_configuration.class_project_submission_end
  end
end
