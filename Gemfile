source 'https://rubygems.org'

# Platform
gem 'rails', '3.2.3'
gem 'jquery-rails'

# Application
gem 'koala'
gem 'haml-rails'
gem 'omniauth-facebook'
gem 'simplecov', :require => false, :group => :test

group :development, :test do
  gem 'sqlite3'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end

group :production do
  gem 'newrelic_rpm'
  gem 'pg'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
