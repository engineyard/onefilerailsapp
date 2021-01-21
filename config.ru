# In config/application.rb, normally we require rails/all
# Instead, we'll only require what we need:
require "action_controller/railtie"
require "active_support"

class HelloWorld < Rails::Application
  config.eager_load = true # necessary to silence warning
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  # Rails won't boot w/o a secret token for session, cookies, etc.
  config.secret_key_base = ENV["SECRET_KEY_BASE"]
  routes.append { get "/hello" => "hello#index" }
end

class HelloController < ActionController::Base
  def index
    render html: "<html><body><h1>Hello World!</h1></body></html>".html_safe
  end
end

# Initialize the app (originally in config/environment.rb)
HelloWorld.initialize!

# Run it (originally in config.ru)
run HelloWorld
