class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def check_allowed_roles user, allowed_roles
    if !allowed_roles.include? user.role
      redirect_user_to_base user
      return
    end
  end

  def redirect_user_to_base user
    if user.student? || user.assistant? || user.teacher? || user.admin?
      redirect_to root_path, notice: "No tienes permisos suficientes."
    elsif user.applicant?
      redirect_to selection_path
    elsif user.employer?
      redirect_to employer_dashboard_coders_path, notice: "No tienes permisos suficientes."
    end
  end

  def no_applicant_allowed
    if current_user.applicant?
      redirect_to selection_path
    end
  end

  def require_admin
    if current_user.student?
      redirect_to root_path, notice: 'No tienes permisos de administración.'
      return
    end
  end

  def require_employer
    if !current_user.employer?
      redirect_to root_path, notice: "No tiene permisos de empleador."
      return
    end
  end

  def append_info_to_payload(payload)
      super
      payload[:user_id] = current_user.id if current_user
  end

end
