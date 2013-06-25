class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate

  private

  def authenticate
    if Rails.env.production?
      username = ApplicationConfig.username
      password = ApplicationConfig.password

      if username.present? && password.present?
        authenticate_or_request_with_http_basic("KarateJournal") do |http_username, http_password|
          http_username == username && http_password == password
        end
      end
    end
  end

end
