require 'bundler'
begin
  Bundler.setup
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rspec'
require 'seedlings'

our_db = ENV["DB"] || 'mongomapper'
puts "Running tests with #{our_db}."
require File.dirname(__FILE__) + "/connections/#{our_db}.rb"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  # clean the database before each test. Might need to switch up to DatabaseCleaner.
  config.before do
    Widget.delete_all
  end
end
