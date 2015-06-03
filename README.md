# Rack::Solvemedia::Dapi

Rack middleware for Solve Media's data collection API.

## Installation

Add this line to your application's Gemfile:

    gem 'rack-solvemedia-dapi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-solvemedia-dapi

## Usage

### Configuration

`Rack::SolveMedia::DAPI` requires a Site ID, provided by Solve Media. If you
have not been given one, please contact Solve Media for more information.

Optional settings:

    * :ssl         -- Defaults to false. Set to true on an SSL website to request the secure version of the Javascript.

#### Rails

A Railtie is included in this gem which will load the middleware automatically.
You will need to set the middleware parameters in your app configuration:

```ruby
config.solvemedia_dapi.site_id = "your site id here"
config.solvemedia_dapi.ssl = false
```

#### Sinatra, etc.

```ruby
use Rack::SolveMedia::DAPI, "your site id here", { :ssl => false }
helpers Rack::SolveMedia::DAPI::Helpers
```

### Sending Data to Solve Media

Within your view, use the helper +sm_dapi_html+ to include the Javascript
collection code. 

```ruby
sm_dapi_html({:email => "..."})
```

You may send an options hash if you need to override any of the configuration
options.

```ruby
sm_dapi_html({:email => "..."}, :ssl => true)
```

When the helper returns output, it also sets a cookie marking the user as 
having had data collected recently. If the user already has this cookie, the
helper will return the empty string, to prevent collecting from the same user
multiple times.

For a Rails site, be sure to mark the output as html safe.

### Best Practices

 * Use the helper only when you have end-user data to pass. Do not send hashes
 with blank values.

 * Only pass information that you have already verified to be valid.
