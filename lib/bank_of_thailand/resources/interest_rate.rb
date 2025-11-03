# frozen_string_literal: true

module BankOfThailand
  module Resources
    # Debt Securities Auction Result (Current)
    #
    # Provides the result of debt securities auctions including government bonds,
    # corporate bonds, and other debt instruments.
    #
    # @see https://gateway.api.bot.or.th/BondAuction/bond_auction_v2/
    class DebtSecurities < Resource
      # Base URL for this API (overrides the global base URL)
      BASE_URL = "https://gateway.api.bot.or.th/BondAuction/bond_auction_v2"

      # Get debt securities auction results
      #
      # @param start_period [String] Start date in YYYY-MM-DD format (e.g., "2017-06-30")
      # @param end_period [String] End date in YYYY-MM-DD format (e.g., "2017-06-30")
      # @return [Hash] Response containing auction result data
      #
      # @example Get auction results for a date range
      #   client.debt_securities.auction_results(
      #     start_period: "2025-01-01",
      #     end_period: "2025-01-31"
      #   )
      #
      # @note Response includes additional information since September 29, 2017:
      #   - Classification of Financial Instrument code (cfi_code)
      #   - Auction Status (auction_st)
      def auction_results(start_period:, end_period:)
        get_with_base_url(
          "#{BASE_URL}/",
          start_period: start_period,
          end_period: end_period
        )
      end

      private

      # Make a GET request with a custom base URL
      # @param url [String] Full URL path
      # @param params [Hash] Query parameters
      # @return [Hash] Response data
      def get_with_base_url(url, params = {})
        client.get(url, params)
      end
    end
  end
end
