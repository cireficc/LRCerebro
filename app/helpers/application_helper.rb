module ApplicationHelper
    
    def generate_hidden_add_fields_data(f, association)
        puts "Add field: " + association.to_s
        new_object = f.object.send(association).klass.new
        id = new_object.object_id
        
        fields = f.fields_for(association, new_object, child_index: id) do |builder|
          render(association.to_s.singularize + "_fields", f: builder)
        end
        
        hidden_field_tag('add_fields_data', nil, data: {id: id, fields: fields.gsub("\n", "")})
  end
  
    # DateTimePicker is a utility that is used site-wide, and often, so this constant should go here
    DATE_TIME_PICKER_FORMAT = "%m/%d/%Y %l:%M %p" # e.g. 07/24/2015 3:41 PM
    
    # Converts each parameter in the object from a string (DateTimePicker text value) to a DateTime object.
    # This allows us to easily convert the text values in parameters for any object before saving to the database
    def convert_date_time_picker_values(object, parameters)
      for param in parameters
        puts "Converting param #{param} with val #{object[param]} && present? #{object[param].present?}"
        object[param] = DateTime.strptime(object[param], DATE_TIME_PICKER_FORMAT) if object[param].present?
      end
    end
    
    def missing_parameters(association_object, required_params)
      missing = Array.new
        
      # Generate an array of errors by checking each required parameter
      for param in required_params
          puts "Param check: #{param}; present?: #{association_object[param].present?}"
          missing << param unless association_object[param].present?
      end
      
      missing
    end
    
    def generate_parameter_errors_message(association, missing_params)
      @message = "There were errors in the #{association}. The following parameters are required, but were missing:"
      @message += "<ol>"
      
      for param in missing_params
        @message += "<li>#{param}</li>"
      end
      @message += "</ol>"
    end
end
