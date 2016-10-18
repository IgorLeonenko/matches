class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Knock::Authenticable

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  helper_method :current_user

  private

  def render_404
    render :file => "public/404.html", :status => 404, :layout => false
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
