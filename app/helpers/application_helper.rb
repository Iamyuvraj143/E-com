module ApplicationHelper

  def is_admin?
    Current.user&.email == "admin@gmail.com"
  end
  
end
