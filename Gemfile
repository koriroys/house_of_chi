source 'https://rubygems.org'

# Platform
gem 'rails', '3.2.11'
gem 'jquery-rails'

# Application
gem 'koala', '~> 1.6.0'
gem 'haml-rails'
gem 'omniauth-facebook'
gem 'kaminari', '~> 0.13.0'
gem 'textacular', '~> 3.0', require: 'textacular/rails'
gem 'pg'
gem 'httparty'

group :test do
  gem 'simplecov', require: false
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'debugger'
  gem 'factory_girl_rails'
  gem 'pry-rails'
end

group :production do
  gem 'newrelic_rpm'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
