module ApplicationHelper
    
    LOCAL_TIME_ZONE = "America/Detroit"
    
    def generate_hidden_add_fields_data(f, association, object_defaults, controller_action)
        
        new_object = f.object.send(association).klass.new(object_defaults)
        id = new_object.object_id
        
        fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
          render("#{@view_path}/#{controller_action.to_s}_#{association.to_s.singularize}_fields", f: builder)
        end
        
        hidden_field_tag('add_fields_data', nil, data: {id: id, fields: fields.gsub("\n", "")})
    end
  
    def generate_errors_html(association, errors)
        puts "Errors: #{errors}"
        html = "<h4>Sorry, but there were errors in your #{association.to_s.downcase}:</h4>"
        html += "<ol>"
        
        for err in errors
            puts "Err: #{err}"
            html += "<li>#{err[0].to_s.humanize}:"
            html += "<ul>"
            for sub_err in 1...err.size
                html += "<li>#{err[sub_err][0].humanize}</li>"
            end
            html += "</ul>"
        end
        
        html += "</ol>"
        html.html_safe
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
