# LG-api
LG API (Rails)

[![Build Status](https://travis-ci.org/201-created/LG-api.svg?branch=master)](https://travis-ci.org/201-created/LG-api) [![Code Climate](https://codeclimate.com/github/201-created/LG-api/badges/gpa.svg)](https://codeclimate.com/github/201-created/LG-api)

## Dev Requirements
* Homebrew (for install packages on Mac OS)
* Git
* Ruby 2.0
* Rubygems
* Bundler
* Postgres DB - `brew install git postgres` on Mac
* Redis

## Setup
 * `bundle install`
 * `bundle exec rake db:setup`
 * `bundle exec rails server`
 * `bundle exec sidekiq` in a separate terminal to run sidekiq which will run async jobs for communicating with CV Server
