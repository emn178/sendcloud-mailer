require 'simplecov'
require 'coveralls'

SimpleCov.add_filter "/spec/"
SimpleCov.add_filter "engine.rb"

if ENV["COVERAGE"]
  SimpleCov.start
elsif ENV["COVERALLS"]
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  Coveralls.wear!
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'sendcloud-mailer'
require 'rspec/its'

# Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each do |file|
#   require file
# end

ActionMailer::Base.delivery_method = :sendcloud
ActionMailer::Base.sendcloud_settings = {
  :api_user => 'USER',
  :api_key => 'KEY'
}
