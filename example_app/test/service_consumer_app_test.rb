require File.expand_path '../test_helper.rb', __FILE__

include Rack::Test::Methods

def app
  ServiceConsumerApp.new
end

def service_name
  "idol-api"
end

describe "GET /" do
  def make_request
    get "/"
  end

  before do
    @vcap_services_value = "{}"
    ENV["VCAP_SERVICES"] = @vcap_services_value
    CF::App::Service.instance_variable_set :@services, nil
  end

  it "displays instructions about restarting the app" do
    make_request

    last_response.status.must_equal 200
    last_response.body.must_match /After binding or unbinding any service instances, restart/
  end

  describe "when no service instances are bound to the app" do
    it "displays a message saying that no instances are bound" do
      make_request

      last_response.status.must_equal 200
      last_response.body.must_match /You haven't bound any instances of the #{service_name} service/
    end
  end

  describe "when there are service instances are bound to the app" do
    before do
      @vcap_services_value = <<JSON
      {
        "idol-api": [
          {
            "name": "extracttext",
            "label": "idol-api",
            "plan": "public",
            "credentials": {
              "apikey": "long-string-with-dashes"
            }
          }
        ]
      }
JSON
      ENV["VCAP_SERVICES"] = @vcap_services_value
      CF::App::Service.instance_variable_set :@services, nil
    end

    it "does not display a message saying that no instances are bound" do
      make_request

      last_response.status.must_equal 200
      last_response.body.wont_match /You haven't bound any instances of the #{service_name} service/
    end

    it "displays a form to submit an URL to the API" do
      make_request

      last_response.body.must_match /<form>/
    end

  end
end

describe "GET /env" do
  def make_request
    get "/env"
  end

  before do
    @vcap_services_value = "{}"
    @vcap_application_value = <<JSON
      {
        "application_name":"service-consumer-application",
        "other":"values"
      }
JSON
    ENV["VCAP_APPLICATION"] = @vcap_application_value
    ENV["VCAP_SERVICES"]    = @vcap_services_value
    CF::App::Service.instance_variable_set :@services, nil
  end

  it "displays instructions for binding" do
    make_request
    last_response.body.must_match /You haven't bound any instances of the #{service_name} service/
  end

  it "shows the value of VCAP_APPLICATION" do
    make_request
    last_response.body.must_include "VCAP_APPLICATION = \n#{@vcap_application_value}"
  end

  describe "when an instance of the service is bound to the app" do
    before do
      @vcap_services_value = <<-JSON
      {
        "idol-api": [
          {
            "name": "extracttext",
            "label": "idol-api",
            "plan": "public",
            "credentials": {
              "apikey": "long-string-with-dashes"
            }
          }
        ]
      }
      JSON

      ENV["VCAP_SERVICES"] = @vcap_services_value
      CF::App::Service.instance_variable_set :@services, nil
      make_request
    end

    it "is successful" do
      last_response.status.must_equal 200
    end

    it "shows the value of VCAP_SERVICES" do
      last_response.body.must_include "VCAP_SERVICES = \n#{@vcap_services_value}"
    end

    it "does not display a message saying that no instances are bound" do
      last_response.body.wont_match /You haven't bound any instances of the #{service_name} service/
    end
  end

  describe "when an instance of a different service is bound to the app" do
    before do
      @vcap_services_value = <<-JSON
        {
          "cleardb": [
            {
              "name": "cleardb-1",
              "label": "cleardb-n/a",
              "plan": "spark",
              "credentials": {
                 "password": "topsecret"
              }
            }
          ]
        }
      JSON
      ENV["VCAP_SERVICES"] = @vcap_services_value

      make_request
    end

    it "is successful" do
      last_response.status.must_equal 200
    end

    it "shows the value of VCAP_SERVICES" do
      last_response.body.must_include "VCAP_SERVICES = \n#{@vcap_services_value}"
    end

    it "displays a message saying that no instances are bound" do
      last_response.body.must_match /You haven't bound any instances of the #{service_name} service/
    end
  end

  describe "when no service instances are bound to the app" do
    it "is successful" do
      make_request

      last_response.status.must_equal 200
    end

    it "shows the value of VCAP_SERVICES" do
      make_request

      last_response.body.must_match /VCAP_SERVICES = \n\{}/
    end
  end
end
