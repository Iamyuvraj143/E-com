class Current < ActiveSupport::CurrentAttributes
  # makes current_user accessible in view files.
  attribute :user
end
