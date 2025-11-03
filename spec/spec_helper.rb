# frozen_string_literal: true

require "bank_of_thailand"
require "webmock/rspec"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Disable external HTTP requests
  config.before do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  # Reset configuration after each test
  config.after do
    BankOfThailand.reset_configuration!
  end
end

# Helper method to stub BOT API requests
# @param method [Symbol] HTTP method (:get, :post)
# @param path [String] API path
# @param response [Hash] Response body
# @param status [Integer] HTTP status code
def stub_bot_request(method, path, response: {}, status: 200)
  stub_request(method, "https://gateway.api.bot.or.th#{path}")
    .to_return(
      status: status,
      body: response.to_json,
      headers: { "Content-Type" => "application/json" }
    )
end
