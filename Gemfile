# frozen_string_literal: true

ruby File.read(".ruby-version").strip

source "https://rubygems.org"

gem "rails", "~> 5.2"

gem "bootsnap", "~> 1"
gem "gds-api-adapters", "~> 52"
gem "gds-sso", "~> 13"
gem "govuk_app_config", "~> 1"
gem "govuk_publishing_components", "~> 9.6"
gem "pg", "~> 1"
gem "plek", "~> 2"
gem "uglifier", "~> 4"

group :development do
  gem "listen", "~> 3"
end

group :test do
  gem "govuk-content-schema-test-helpers"
  gem "simplecov", "~> 0.16"
end

group :development, :test do
  gem "byebug", "~> 10"
  gem "capybara"
  gem "factory_bot_rails", "~> 4.0"
  gem "govuk-lint", "~> 3"
  gem "govuk_schemas", "~> 3.2"
  gem "rspec-rails", "~> 3"
  gem "webmock", "~> 3"
end
