# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

if ENV['RAILS_ENV'] == 'production'  # don't bother on dev
  ENV['GEM_PATH'] = '/home/kura2/.gem/ruby/1.8' #+ ':/usr/lib/ruby/gems/1.8'  # Need this or Passenger fails to start
#  require '/home/kura2/.gem/ruby/1.8/gems/RedCloth-4.1.9/lib/redcloth.rb'  # Need this for EACH LOCAL gem you want to use, otherwise it uses the ones in /usr/lib
end

# Redirect logger to console if using it
if "irb" == $0
   RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end


Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'rake' # ruby make. Used by all scripts.
#  config.gem 'ruby-openid', :lib => 'openid' # lets us speak OpenID a bit easier
  config.gem 'capistrano' # ye standard deployment tools
  config.gem 'mperham-memcache-client', :lib => 'memcache', :source => 'http://gems.github.com' # bugfix tweak of standard memcache client
  config.gem 'rubaidh-google_analytics', :lib => 'rubaidh/google_analytics', :source => 'http://gems.github.com' # adds google analytics' code to all pages
  config.gem 'will_paginate', :version => '>= 2.3.11', :source => 'http://gemcutter.org' # the standard way to paginate things. We override it to use AJAX.
  config.gem 'uuidtools' # generates universally unique IDs (UUIDs) with good randomness, plus some associated utilities 
  config.gem "grosser-rpx_now", :lib => "rpx_now", :source => "http://gems.github.com" # handles and normalizes OpenID/Facebook/Twitter/etc logins
  config.gem 'lockfile' # used by mail reader script, ensures only one copy is running at a time
  config.gem "friendly_id" # allows "nice" urls, e.g. /users/saizai instead of /users/1
  config.gem 'chrislloyd-gravtastic', :lib => 'gravtastic', :version => '>= 2.1.0' # displays Gravatar profile images; tied to a user's email address
  config.gem 'sishen-rtranslate', :lib => 'rtranslate', :version => '>= 1.0' # interface to Google Translate
  config.gem 'ar-extensions', :version => '>= 0.9.2' # adds more efficient bulk tools to ActiveRecord (e.g. import)
  config.gem 'bullet', :source => 'http://gemcutter.org' # notifies dev of N+1 (aka eager loading) bugs
  config.gem 'validation_reflection', :version => '>= 0.3.5' # required by Validatious
  config.gem 'validatious-on-rails', :source => 'http://gemcutter.org' # hooks in Validatious client-side JS/AJAX validation
  config.gem 'erubis'#, :source => "http://gems.github.com" # required by rails_xss plugin. Remove after rails 3.0 integrates it.
#  config.gem 'tmtm-ruby-mysql', :lib => 'Mysql', :source => 'http://gems.github.com'
#  config.gem "sqlite3-ruby", :lib => "sqlite3"
  config.gem 'rack', :version => '~> 1.0.1'
#  config.gem 'test-spec', :version => '~> 0.9.0' # required for rack-rack-contrib (note: 0.10.0 is current)
#  config.gem 'rack-rack-contrib', :lib => 'rack/contrib',  :source => 'http://gems.github.com'
  config.gem 'geoip'
  
  # Not frozen because they cause conflicts and/or require native extensions
  config.gem 'rmagick', :lib => 'RMagick' # NOTE: installation for this is nontrivial. See its website (+ the DreamHost wiki, if on DH)
  config.gem 'mms2r'
  config.gem 'hpricot' # required by mms2r
  config.gem 'francois-piston', :lib => 'piston', :source => 'http://gems.github.com'
  config.gem 'SystemTimer', :lib => 'system_timer' # makes memcache faster
#  config.gem 'RedCloth', :lib => 'redcloth'
  config.gem 'bluecloth' # lowercase is 2.x, camelcase is 1.x
  config.gem 'utf8proc'
  # config.gem 'fiveruns_tuneup', :version => '>= 0.8.20'
  
  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/sweepers )
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  config.active_record.observers = :user_observer, :contact_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'
  config.active_record.default_timezone = :utc # only :utc and :local are valid
  
  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

