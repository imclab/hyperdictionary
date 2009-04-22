# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!

config.after_initialize do 
  require 'application_controller' unless Object.const_defined?(:ApplicationController)
  LoggedExceptionsController.class_eval do
    # set the same session key as the app
    session :session_key => SESSION_KEY
    
    # include any custom auth modules you need
    include AuthenticatedSystem
    
    before_filter :login_required
    
    # optional, sets the application name for the rss feeds
    self.application_name = APP_NAME
    
    protected
      # only allow admins
      # this obviously depends on how your auth system works
      def authorized?
        current_user.has_role?('admin')
      end
      
      # assume app's login required doesn't use http basic
      def login_required_with_basic
        respond_to do |accepts|
          # alias_method_chain will alias the app's login_required to login_required_without_basic
          accepts.html { login_required_without_basic }
          
          # access_denied_with_basic_auth is defined in LoggedExceptionsController
          # get_auth_data returns back the user/password pair
          accepts.rss do
            access_denied_with_basic_auth unless self.current_user = User.authenticate(*get_auth_data)
          end
        end
      end
      
      alias_method_chain :login_required, :basic
  end
end