module ApplicationHelper

  def is_admin?
    current_user&.email == "admin@gmail.com"
  end
  
end
