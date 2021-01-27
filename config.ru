# In config/application.rb, normally we require rails/all
# Instead, we'll only require what we need:
require "action_controller/railtie"

class HelloWorld < Rails::Application
  config.eager_load = true # necessary to silence warning
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  # Rails won't boot w/o a secret token for session, cookies, etc.
  config.secret_key_base = SecureRandom.uuid  
  config.action_dispatch.default_headers = { 'X-Frame-Options' => 'ALLOWALL' }
  routes.append { root :to => "hello#index" }
end

class HelloController < ActionController::Base
  @@count = 1
  def index
    @@count = @@count + 1
    render html: "<html><body><h1>Hello World! #{@@count} </h1></body></html>".html_safe
  end
end

# Initialize the app (originally in config/environment.rb)
HelloWorld.initialize!

# Run it (originally in config.ru)
run HelloWorld
