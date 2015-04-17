require 'sinatra/base'
require 'cf-app-utils'
require_relative 'idol'

class ServiceConsumerApp < Sinatra::Base

  #declare the routes used by the app
  get "/" do
    if bindings_exist
      @results = Idol.extract_text params['input-url'] if params['input-url']
      erb :index
    else
      warn_of_missing_binding
    end
  end

  get "/env" do
    content_type "text/plain"

    response_body = "VCAP_SERVICES = \n#{vcap_services}\n\n"
    response_body << "VCAP_APPLICATION = \n#{vcap_application}\n\n"
    response_body << warn_of_missing_binding unless bindings_exist
    response_body
  end

  # helper methods
  private

  def warn_of_missing_binding
    <<-HTML.gsub(/^\s+\|/, '')
      | <h1>Missing Service</h1>
      | <p>
      |   You haven't bound any instances of the idol-api service.
      |   After binding or unbinding any service instances, restart this
      |   application with 'cf restart [appname]'
      | </p>
    HTML
  end

  def vcap_services
    ENV["VCAP_SERVICES"]
  end

  def vcap_application
    ENV["VCAP_APPLICATION"]
  end

  def bindings_exist
    vcap_services &&
      !(CF::App::Credentials.find_all_by_service_label(service_name).empty?)
  end

  def service_name
    "extracttext"
  end

end
