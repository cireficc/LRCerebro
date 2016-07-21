module ApplicationHelper
    
    LOCAL_TIME_ZONE = "America/Detroit"
    
    def generate_hidden_add_fields_data(f, association, object_defaults, controller_action, ignore_role=false)
        
        new_object = f.object.send(association).klass.new(object_defaults)
        id = new_object.object_id
        
        fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
          role_path = (ignore_role) ? "" : "#{@view_path}/"
          controller_action_path = (controller_action) ? "#{controller_action.to_s}_" : ""
          path = "#{role_path}#{controller_action_path}#{association.to_s.singularize}_fields"
          
          render(path, f: builder)
        end
          
        hidden_field_tag('add_fields_data', nil, data: {id: id, fields: fields.gsub("\n", "")})
    end
    
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
        body += (sprintf "%-15s %s\n", "G number:", u.g_number)
        body += (sprintf "%-15s %s\n", "Role:", u.role)
        body += (sprintf "%-15s %s\n", "URL:", request.url)
    end
    
    def last_page
       session[:last_page] 
    end
    
    def self.time_local(time)
        ActiveSupport::TimeZone.new(LOCAL_TIME_ZONE).local_to_utc(time) 
    end
end
