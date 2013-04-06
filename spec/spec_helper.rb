$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'pry'
require 'database_cleaner'
require 'mongoid_lol_finder'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

# requiring auxilliary files
Dir["#{File.dirname(__FILE__)}/auxilliary/*.rb"].each {|f| require f}

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.orm = :moped

RSpec.configure do |config|
  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end

Mongoid.load!("spec/mongoid.yml", :test)

