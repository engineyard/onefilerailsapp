require 'action_controller/railtie'
require 'pp'

class SurveyApp < Rails::Application
  config.eager_load = true # necessary to silence warning
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  config.secret_key_base = SecureRandom.uuid    # Rails won't start without this
  config.action_dispatch.default_headers = { 'X-Frame-Options' => 'ALLOWALL' }
  routes.append { root :to => "survey#index" }
  routes.append { post "/survey" => "survey#index" }
end

class SurveyController < ActionController::Base
  @@responses = {}
  def index
    # check who the user is, or by client IP address
    puts request.remote_ip
    #@@count = @@count + 1
    if params["activity_choice"]
      puts "The user chose #{params["activity_choice"]}"
      render html: results_html(params["activity_choice"]).html_safe
    else
      puts "First time."
      render html: form_html.html_safe
    end
  end
  
  def form_html
    <<-FORM_HTML
    <h3>What is your favorite weekend activity?</h3>
    <form method="post" action="survey">
      <div class="4u 12u$(small)">
	    <input type="radio" id="netflix" name="activity_choice" value="Netflix" checked>
		<label for="netflix">Netflix</label>
	  </div>
      <div class="4u 12u$(small)">
	    <input type="radio" id="gaming" name="activity_choice" value="gaming">
		<label for="gaming">Gaming</label>
	  </div>
      <div class="4u 12u$(small)">
	    <input type="radio" id="dining" name="activity_choice" value="dining">
		<label for="dining">Fine Dining</label>
	  </div>
	  <div class="12u$">
		<input type="submit" value="Send Message" />
	  </div>
    </form>
    FORM_HTML
  end

  def results_html(answer)
    <<-RESULTS_HTML
    <h3>What is your favorite weekend activity?</h3>
    Thanks for participating? You chose #{answer}.<br/>
    Overall survey results<br/>
    RESULTS_HTML
  end
end

SurveyApp.initialize!
run SurveyApp
