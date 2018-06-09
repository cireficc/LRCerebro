class MiniProjectDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def producteevified
    if added_to_producteev?
      h.content_tag :span, "Yes", class: "label label-success"
    else
      h.content_tag :span, "No", class: "label label-danger"
    end
  end

  def stringified_resources
    resources.reject(&:empty?).join(", ")
  end

  def stringified_publish_methods
    publish_methods.reject(&:empty?).map(&:titleize).join(", ")
  end

  def supplemental_materials_string
    supplemental_materials ? "Yes" : "No"
  end
end
