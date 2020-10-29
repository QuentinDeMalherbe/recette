class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    if current_user.preference
      listes_path
    else
      new_preference_path
    end
  end
end
