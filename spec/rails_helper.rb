# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc.,
# in spec/support/ and its subdirectories.
# Automatically requires all files in the support directory.
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Ensure database schema is up-to-date before running tests
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Include matchers and factory methods
  config.include Shoulda::Matchers::ActiveModel, type: :model
  config.include Shoulda::Matchers::ActiveRecord, type: :model
  config.include FactoryBot::Syntax::Methods

  # Set fixture path (if you use fixtures)
  config.fixture_paths = [Rails.root.join('spec/fixtures')]

  # Use transactional fixtures for faster tests
  config.use_transactional_fixtures = true

  # Automatically infer spec type from file location (e.g., models, controllers)
  config.infer_spec_type_from_file_location!

  # Filter Rails backtrace for cleaner output
  config.filter_rails_from_backtrace!

  # Include custom helpers (if you add any in spec/support)
  # config.include RequestSpecHelper, type: :request
end
