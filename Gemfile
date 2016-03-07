source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'

gem 'execjs'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Pagination
gem 'kaminari'
gem 'bootstrap-sass'
gem 'bootstrap-kaminari-views'
gem 'bootstrap_form'

gem 'font-awesome-sass', '~> 4.5.0'
gem 'bootstrap-datepicker-rails'
gem 'seed_dump'

gem 'geocoder'

gem 'mini_exiftool'
gem 'phashion'
gem "mini_magick"

gem 'jquery-turbolinks'
gem 'squeel'
gem 'puma'

gem 'dropbox-sdk'

gem 'resque'
gem 'resque-loner'


gem "haml-rails", "~> 0.9"

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server


# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development


source 'https://rails-assets.org/' do 
  gem 'rails-assets-adminlte'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'mocha'
  gem 'test-unit'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-rails-collection'
  gem "capistrano-resque", "~> 0.2.2", require: false
  gem 'foreman'
  gem 'awesome_print', :require => 'ap'
  gem 'pry-rails'
  gem 'pry-byebug'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

end


group :production do
  gem 'mysql2'
end
