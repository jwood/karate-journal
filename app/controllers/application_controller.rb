require 'app_config'

class ApplicationController < ActionController::Base

  htpasswd_file = AppConfig.instance.htpasswd_file
  htpasswd :file => htpasswd_file unless htpasswd_file.blank?

  layout 'standard'
end
