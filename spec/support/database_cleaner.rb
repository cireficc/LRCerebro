RSpec.configure do |config|

  # TODO: Decide if we need to change the defaults or not
  #config.before(:suite) do
  #  DatabaseCleaner.strategy = :transaction
  #  DatabaseCleaner.clean_with(:truncation)
  #end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
