module ApplicationHelper
    
    def generate_hidden_add_fields_data(f, association, object_defaults)
        
        new_object = f.object.send(association).klass.new(object_defaults)
        id = new_object.object_id
        
        fields = f.fields_for(association, new_object, child_index: id) do |builder|
          render(association.to_s.singularize + "_fields", f: builder)
        end
        
        hidden_field_tag('add_fields_data', nil, data: {id: id, fields: fields.gsub("\n", "")})
  end
end
