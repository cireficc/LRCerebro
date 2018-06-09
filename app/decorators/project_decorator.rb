class ProjectDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end
  
  def status
    if approved?
      h.content_tag :span, "Approved", class: "label label-success"
    else
      h.content_tag :span, "Pending", class: "label label-danger"
    end
  end

  def stringified_publish_methods
    publish_methods.reject(&:empty?).map(&:titleize).join(", ")
  end
end
