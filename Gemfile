source 'https://rubygems.org'

# Ruby
gem 'coveralls'
gem 'json'
gem 'json-stream'
gem 'minitest', "5.26.2"
gem 'minitest-ci'
gem 'minitest-reporters'
gem 'oj'
gem 'ruby-prof'
gem 'simplecov', "0.21.2"

# Rack
gem 'prometheus-client'
gem 'puma'
gem 'rack'
gem 'rack-test'
gem 'rest-client'
gem 'thin'

gem 'capybara'
gem 'nokogiri'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'sprockets'
gem 'selenium-webdriver'
gem 'uri'

# minitest is locked to 5.26.2 because with 6.0.0 
# the augmented reporting fails. Specifically, in, eg
# differ/test/server/lib/id58_test_base.rb 
# there is this...
#
# reporters = [
#   Minitest::Reporters::DefaultReporter.new,
#   Minitest::Reporters::SlimJsonReporter.new,
#   Minitest::Reporters::JUnitReporter.new("#{ENV.fetch('COVERAGE_ROOT')}/junit")
# ]
# Minitest::Reporters.use!(reporters)
#
# which works for 5.26.0 (SlimJsonReporter produces test_metrics.json)
# but fails for 6.0.0 (SlimJsonReporter does NOT produce test_metrics.json)