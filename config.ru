# In config/application.rb, normally we require rails/all
# Instead, we'll only require what we need:
require "action_controller/railtie"


class HelloWorld < Rails::Application
  config.eager_load = true # necessary to silence warning
  config.api_only = true # removes middleware we dont need
  config.logger = Logger.new($stdout)
  Rails.logger  = config.logger
  config.secret_key_base = ENV["SECRET_KEY_BASE"] # Rails won't boot w/o a secret token for session, cookies, etc.
  routes.append { post "/hello" => "hello#index" }
end

class HelloController < ActionController::Base
  def index
    render "Hello World!"
  end
end

# Initialize the app (originally in config/environment.rb)
HelloWorld.initialize!

# Run it (originally in config.ru)
run HelloWorld
