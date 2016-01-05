class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    if resource.is_a? Manager
      management_path
    end
  end

  def after_sign_out_path_for(scope)
    if scope == :manager
      new_manager_session_path
    end
  end

  def layout_by_resource
    if devise_controller? && resource_name == :manager && action_name == "new"
      "management"
    end
  end

end
