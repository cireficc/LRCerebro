module ApplicationHelper
    
    def generate_hidden_add_fields_data(f, association, object_defaults)
        
        new_object = f.object.send(association).klass.new(object_defaults)
        id = new_object.object_id
        
        fields = f.fields_for(association, new_object, child_index: id) do |builder|
          render(association.to_s.singularize + "_fields", f: builder)
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
end
