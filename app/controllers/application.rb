require 'app_config'

class ApplicationController < ActionController::Base

  htpasswd_file = AppConfig.instance.htpasswd_file
  htpasswd :file => htpasswd_file unless htpasswd_file.blank?

  session :session_key => '_karate-journal_session_id'
  layout 'standard'
end
