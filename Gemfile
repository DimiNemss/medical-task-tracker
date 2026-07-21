source "https://rubygems.org"

gem "rails", "~> 8.1.3"

gem "pg", "~> 1.1"

gem "puma", ">= 5.0"

gem "bootsnap", require: false

gem "tzinfo-data", platforms: %i[windows jruby]

# Serialization
gem "blueprinter"

# Pagination
gem "pagy", "~> 43.6"
gem "ostruct"

# API docs
gem "rswag"

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"

  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  gem "rubocop"
  gem "rubocop-rails-omakase", require: false

  gem "brakeman", require: false
  gem "bundler-audit", require: false
end
