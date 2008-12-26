require 'app_config'

class ApplicationController < ActionController::Base

  htpasswd_file = AppConfig.instance.htpasswd_file
  htpasswd :file => htpasswd_file unless htpasswd_file.blank?

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_karate-journal_session_id'

  # Use the standard layout for all views
  layout 'standard'

end
