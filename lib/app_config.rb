require 'singleton'

#------------------------------------------------------------------------------#
# This class defines application specific configuration
#------------------------------------------------------------------------------#
class AppConfig
  include Singleton

  #----------------------------------------------------------------------------#
  # Specifies the password file used to access the application.  Set to nil to
  # disable HTTP password protection.
  #----------------------------------------------------------------------------#
  attr_accessor :htpasswd_file

  #----------------------------------------------------------------------------#
  # Set the default config values for the application
  #----------------------------------------------------------------------------#
  def initialize
    if RAILS_ENV == 'production'
      @htpasswd_file = '/path/to/password_file' 
    end
  end

end

