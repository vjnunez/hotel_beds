require "dotenv"
Dotenv.load

if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end
end
