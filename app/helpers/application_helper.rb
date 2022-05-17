module ApplicationHelper

  def is_admin?
    current_user&.email == "ydodiya@gammastack.com"
  end
  
end
