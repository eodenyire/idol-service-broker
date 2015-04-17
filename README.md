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

# License

IDOL API service broker and sample application.
Copyright (C) 2015  Eloy Espinaco

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

It includes code from
[cloudfoundry-samples/github-service-broker-ruby][https://github.com/cloudfoundry-samples/github-service-broker-ruby]
under the Apache Licence Version 2.0.
