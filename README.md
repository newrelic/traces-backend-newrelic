# traces-backend-newrelic

This is a New Relic backend implementation of the [Traces](https://github.com/socketry/traces) gem.


## Quick start

Add the gem to your project's Gemfile. This will also install `newrelic_rpm`, the New Relic Ruby agent.

```ruby
gem 'traces-backend-newrelic'
```

and run `bundle install` to activate the new gem.

When starting your application, set the `TRACES_BACKEND` environment variable to `traces/backend/newrelic`.

```bash
TRACES_BACKEND=traces/backend/newrelic bundle exec rails s
```



## Testing

```bash
TRACES_BACKEND=traces/backend/newrelic rspec
```
