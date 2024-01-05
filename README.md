# traces-backend-newrelic

This is a New Relic backend implementation for the [Traces](https://github.com/socketry/traces) gem.


## Quick start

Add the Ruby agent to your project's Gemfile.

```ruby
gem 'traces-backend-newrelic'
```

and run `bundle install` to activate the new gem.

When starting your application, set the `TRACES_BACKEND` environment variable to `traces/backend/newrelic`.

```bash
TRACES_BACKEND=traces/backend/newrelic bundle exec rails s
```



## Testing

```
TRACES_BACKEND=traces/backend/newrelic rspec
```
