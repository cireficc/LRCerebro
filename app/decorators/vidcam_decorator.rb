class VidcamDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def stringified_publish_methods
    publish_methods.map(&:titleize).join(", ")
  end

  def upload_to_ensemble_string
    upload_to_ensemble ? "Yes" : "No"
  end
end
