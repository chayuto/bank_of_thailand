# frozen_string_literal: true

require_relative "bank_of_thailand/version"
require_relative "bank_of_thailand/errors"
require_relative "bank_of_thailand/configuration"
require_relative "bank_of_thailand/response"
require_relative "bank_of_thailand/client"
require_relative "bank_of_thailand/resource"
require_relative "bank_of_thailand/resources/exchange_rate"
require_relative "bank_of_thailand/resources/interest_rate"
require_relative "bank_of_thailand/resources/statistics"
require_relative "bank_of_thailand/resources/average_exchange_rate"
require_relative "bank_of_thailand/resources/deposit_rate"
require_relative "bank_of_thailand/resources/financial_holidays"
require_relative "bank_of_thailand/resources/interbank_rate"
require_relative "bank_of_thailand/resources/loan_rate"
require_relative "bank_of_thailand/resources/swap_point"
require_relative "bank_of_thailand/resources/implied_rate"
require_relative "bank_of_thailand/resources/search_series"

# Ruby wrapper for the Bank of Thailand (BOT) API
#
# Provides access to three documented API products:
# - Weighted-average Interbank Exchange Rate (THB/USD)
# - Debt Securities Auction Results
# - BOT License Check
#
# @example Configure and use the client
#   BankOfThailand.configure do |config|
#     config.api_token = "your_api_token"
#   end
#
#   client = BankOfThailand::Client.new
#   rates = client.exchange_rate.daily(
#     start_period: "2025-01-01",
#     end_period: "2025-01-31"
#   )
#
# @see https://portal.api.bot.or.th BOT API Portal
module BankOfThailand
  class Error < StandardError; end

  class << self
    # Create a new client instance
    # @param config [Configuration, nil] Optional configuration
    # @yield [Configuration] optional configuration block
    # @return [Client] new client instance
    #
    # @example
    #   client = BankOfThailand.client do |config|
    #     config.api_token = "token"
    #   end
    def client(config = nil, &block)
      Client.new(config, &block)
    end
  end
end
