class SearchPolicy < Struct.new(:user, :search)
  
  def index?
    user && (user.director? || user.labasst? || user.faculty?)
  end
end
