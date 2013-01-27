source 'https://rubygems.org'

# Platform
gem 'rails', '3.2.11'
gem 'jquery-rails'

# Application
gem 'koala', '~> 1.6.0'
gem 'haml-rails'
gem 'omniauth-facebook'
gem 'simplecov', :require => false, :group => :test
gem 'kaminari', '~> 0.13.0'
gem 'texticle', require: 'texticle/rails'
gem 'pg'
gem 'httparty'

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'debugger'
  gem 'factory_girl_rails'
end

group :production do
  gem 'newrelic_rpm'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
