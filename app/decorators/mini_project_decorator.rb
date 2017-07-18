class MiniProjectDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def stringified_resources
    resources.join(", ")
  end

  def stringified_publish_methods
    publish_methods.map(&:titleize).join(", ")
  end
  
  def supplemental_materials_string
    supplemental_materials ? "Yes" : "No"
  end
end
