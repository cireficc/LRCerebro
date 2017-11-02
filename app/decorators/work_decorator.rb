class WorkDecorator < Draper::Decorator
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
	
end
