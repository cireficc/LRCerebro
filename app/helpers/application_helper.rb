module ApplicationHelper
    
    def generate_hidden_add_fields_data(f, association)
        puts "Add field: " + association.to_s
        new_object = f.object.send(association).klass.new
        id = new_object.object_id
        
        fields = f.fields_for(association, new_object, child_index: id) do |builder|
          render(association.to_s.singularize + "_fields", f: builder)
        end
        
        #link_to(name, '#', id: "add_fields_data", data: {id: id, fields: fields.gsub("\n", "")})
        hidden_field_tag('add_fields_data', nil, data: {id: id, fields: fields.gsub("\n", "")})
  end
end
