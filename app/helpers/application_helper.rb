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
end
