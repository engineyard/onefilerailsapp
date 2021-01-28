require 'action_controller/railtie'

SURVEY_CHOICES = ["Netflix", "Gaming", "Dining", "Nightclub"]

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
    choice = params["activity_choice"]
    if choice
      count = @@responses[choice]
      if count.nil?
        @@responses[choice] = 1
      else
        @@responses[choice] = count + 1
      end
      render html: results_html(choice).html_safe
    else
      render html: form_html.html_safe
    end
  end
  
  def form_html
    form_start = <<-FORM_START_HTML
    <h3>What is your favorite weekend activity?</h3>
    <div class="row uniform">
    <form method="post" action="survey">
    FORM_START_HTML
    
    form_end = <<-FORM_END_HTML
	  <br/><br/><div class="12u$">
		<input type="submit" value="Submit" style="background-color: #5AA6ED; color: #ffffff !important; font-family: Taviraj, serif; font-size: 14; height: 41; padding: 0; border-radius: 5px; width: 100" />
	  </div>
    </form>
    </div>
    FORM_END_HTML
    
    buffer = form_start
    SURVEY_CHOICES.each do |choice|
      buffer = "#{buffer}#{button_html(choice)}"
    end
    "#{buffer}#{form_end}"
  end

  def button_html(choice)
    <<-CHOICE_HTML
      <div class="4u 12u$(small)">
	    <input type="radio" id="#{choice}" name="activity_choice" value="#{choice}" checked>
		<label for="netflix">#{choice}</label>
	  </div>
    CHOICE_HTML
  end
  
  def results_html(answer)
    header = <<-RESULTS_HTML
    <h3>What is your favorite weekend activity?</h3><div style="color: #A9A9A9">
    Thanks for participating? You chose <span style="color: #8FC0F1">#{answer}</span>. Overall results:<br/></div><hr/>
    <div class="container horizontal rounded">
    RESULTS_HTML
    
    buffer = ""
    SURVEY_CHOICES.each do |choice|
      count = @@responses[choice]
      count = 0 unless not count.nil?
      buffer = "#{buffer}<pre>#{choice.rjust(10, ' ')}: #{count}</pre>"
    end
    
    "#{header}#{buffer}</div>"
  end
end

SurveyApp.initialize!
run SurveyApp
