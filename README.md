IDOL service broker
===================

This repo contains two [Sinatra][] applications, a [service broker][] for the
IDOL API and an example app which can use instances of the service advertised
by the broker.

The IDOL API credentials needs to be added to the `config/settings.yml` before
you deploy.

### Deploying the Service Broker

This service broker application can be deployed on any environment or hosting
service.

For example, to deploy this broker application to Cloud Foundry with `cf`.

```
cf login
git clone git@github.com:eloyesp/idol-service-broker.git
cd idol-service-broker/service_broker

# fill credentials
$EDITOR config/settings.yml

# push the service broker
cf push

# register the service broker
cf create-service-broker idol admin password http://idol-service-broker.cf.altoros.com/

# make the service plan public
cf enable-service-access idol

# and create an instance
cf create-service idol try idol-extracttext-sample
```

Example application
-------------------

We've provided an example application you can push to Cloud Foundry, which can
be bound to an instance of the service. After binding the example
application to a service instance, Cloud Foundry makes credentials available in
the VCAP\_SERVICES environment variable.

### Deploying the example app

With `cf`:

```
cd idol-service-broker/example_app/
cf push
```

The binding should be automatic with the manifest provided.

Point your web browser at `http://idol-sample-consumer.cf.altoros.com` and you
should see the example app's interface. If the app has not been bound to
a service instance, you will see a meaningful error.

  [Sinatra]: https://github.com/sinatra/sinatra
  [service broker]: http://docs.cloudfoundry.org/services/api.html
