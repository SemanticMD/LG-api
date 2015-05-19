source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '4.2.0'
gem 'pg'
gem 'sass-rails', '~> 5.0'


# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Use Unicorn as the app server
gem 'unicorn'

# See https://github.com/activeadmin/activeadmin
gem 'activeadmin', github: 'activeadmin'
gem 'devise'
gem 'inherited_resources', github: 'josevalim/inherited_resources', branch: 'rails-4-2'

# Serve static assets from heroku and other things
gem 'rails_12factor', group: :production

gem 'aws-sdk'

gem 'rack-cors'

gem 'oat'

gem 'redis-rails'
gem 'sidekiq'
gem 'sinatra', :require => nil # for sidekiq
gem 'rest-client'

group :development, :test do
  gem 'rspec-rails'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'foreman'

  gem 'fabrication'
  gem 'faker'

  gem 'rspec-its'

  # For debugging
  # To set a breakpoint, put "binding.remote_pry" in your ruby code,
  # and run "pry-remote" in any terminal window
  # Pry Debugger commands https://github.com/nixme/pry-debugger
  gem 'pry-remote'

end
