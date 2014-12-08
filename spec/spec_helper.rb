# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Requires factories defined in spree_core
require 'spree/testing_support/factories'
require 'spree/testing_support/order_walkthrough'
require 'spree/testing_support/preferences'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.mock_with :rspec
  config.use_transactional_fixtures = false

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include FactoryGirl::Syntax::Methods
  config.include Spree::TestingSupport::Preferences


  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before do
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
    reset_spree_preferences
  end

  config.after do
    DatabaseCleaner.clean
  end

end
