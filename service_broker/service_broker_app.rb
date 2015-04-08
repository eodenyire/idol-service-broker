require 'sinatra'
require 'json'
require 'yaml'

class ServiceBrokerApp < Sinatra::Base
  #configure the Sinatra app
  use Rack::Auth::Basic do |username, password|
    credentials = self.app_settings.fetch("basic_auth")
    username == credentials.fetch("username") and password == credentials.fetch("password")
  end

  #declare the routes used by the app

  # CATALOG
  get "/v2/catalog" do
    content_type :json

    self.class.app_settings.fetch("catalog").to_json
  end

  # PROVISION
  put "/v2/service_instances/:id" do |id|
    content_type :json
    status 200
    {}.to_json
  end

  # BIND
  put '/v2/service_instances/:instance_id/service_bindings/:id' do |instance_id, binding_id|
    credentials = self.class.app_settings['idol']
    content_type :json
    status 200
    {"credentials" => credentials}.to_json
  end

  # UNBIND
  delete '/v2/service_instances/:instance_id/service_bindings/:id' do |instance_id, binding_id|
    content_type :json
    status 200
    '{}'
  end

  # UNPROVISION
  delete '/v2/service_instances/:instance_id' do |instance_id|
    content_type :json

    status 200
    '{}'
  end

  #helper methods
  private

  def self.app_settings
    settings_filename = defined?(SETTINGS_FILENAME) ? SETTINGS_FILENAME : 'config/settings.yml'
    @app_settings ||= YAML.load_file(settings_filename)
  end

end
