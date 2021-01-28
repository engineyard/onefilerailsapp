require "action_controller/railtie"

class SurveyApp < Rails::Application
  config.eager_load = true # necessary to silence warning
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  config.secret_key_base = SecureRandom.uuid    # Rails won't start without this
  config.action_dispatch.default_headers = { 'X-Frame-Options' => 'ALLOWALL' }
  routes.append { root :to => "survey#index" }
end

class SurveyController < ActionController::Base
  @@count = 1
  def index
    @@count = @@count + 1
    render html: "<html><body><h1>Hello World! #{@@count} </h1></body></html>".html_safe
  end
end

SurveyApp.initialize!
run SurveyApp
