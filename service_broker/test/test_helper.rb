if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/spec'
require 'rack/test'
require 'mocha/setup'
require 'webmock/minitest'
require 'pry'

WebMock.disable_net_connect!(allow: 'codeclimate.com')

SETTINGS_FILENAME = "test/config/settings.yml"

require_relative '../service_broker_app.rb'
