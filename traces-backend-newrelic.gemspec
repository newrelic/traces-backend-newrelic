# frozen_string_literal: true

require_relative 'lib/traces/backend/newrelic/version'

Gem::Specification.new do |s|
  s.name = 'traces-backend-newrelic'
  s.version = Traces::Backend::NewRelic::VERSION
  s.required_ruby_version = '>= 2.4.0'
  s.authors = ['Tanna McClure', 'Kayla Reopelle', 'James Bunch', 'Hannah Ramadan']
  s.licenses = ['Apache-2.0']
  s.description = 'New Relic implementation for the Traces gem'
  s.email = 'support@newrelic.com'
  s.homepage = 'https://github.com/newrelic/traces-backend-newrelic'
  s.summary = 'A traces backend for New Relic'

  s.files = Dir.glob('{lib}/**/*', File::FNM_DOTMATCH, base: __dir__)

  s.add_dependency 'newrelic_rpm'
  s.add_dependency 'traces', '~> 0.11.1'

  s.add_development_dependency 'rspec'
end
