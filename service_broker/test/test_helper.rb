ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/spec'
require 'rack/test'
require 'mocha/setup'
require 'webmock/minitest'
require 'pry'

WebMock.disable_net_connect!(allow: 'codeclimate.com')

require_relative '../service_broker_app.rb'
