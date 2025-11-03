# frozen_string_literal: true

module BankOfThailand
  module Resources
    # Weighted-average Interbank Exchange Rate - THB / USD
    #
    # This API provides weighted-average interbank exchange rates calculated from
    # daily interbank purchases and sales of US Dollar (against THB) for transactions
    # worth more than or equal to 1 million USD.
    #
    # @see https://gateway.api.bot.or.th/Stat-ReferenceRate/v2
    class ExchangeRate < Resource
      # Base URL for this API (overrides the global base URL)
      BASE_URL = "https://gateway.api.bot.or.th/Stat-ReferenceRate/v2"

      # Get daily weighted-average interbank exchange rate
      #
      # @param start_period [String] Start date in YYYY-MM-DD format (e.g., "2017-06-30")
      # @param end_period [String] End date in YYYY-MM-DD format (e.g., "2017-06-30")
      # @return [Hash] Response containing daily exchange rate data
      #
      # @example Get daily rates for a date range
      #   client.exchange_rate.daily(
      #     start_period: "2025-01-01",
      #     end_period: "2025-01-31"
      #   )
      def daily(start_period:, end_period:)
        get_with_base_url(
          "#{BASE_URL}/DAILY_REF_RATE/",
          start_period: start_period,
          end_period: end_period
        )
      end

      # Get monthly weighted-average interbank exchange rate
      #
      # @param start_period [String] Start period in YYYY-MM format (e.g., "2017-06")
      # @param end_period [String] End period in YYYY-MM format (e.g., "2017-06")
      # @return [Hash] Response containing monthly exchange rate data
      #
      # @example Get monthly rates
      #   client.exchange_rate.monthly(
      #     start_period: "2025-01",
      #     end_period: "2025-03"
      #   )
      def monthly(start_period:, end_period:)
        get_with_base_url(
          "#{BASE_URL}/MONTHLY_REF_RATE/",
          start_period: start_period,
          end_period: end_period
        )
      end

      # Get quarterly weighted-average interbank exchange rate
      #
      # @param start_period [String] Start period in YYYY-QN format (e.g., "2017-Q1")
      # @param end_period [String] End period in YYYY-QN format (e.g., "2017-Q1")
      # @return [Hash] Response containing quarterly exchange rate data
      #
      # @example Get quarterly rates
      #   client.exchange_rate.quarterly(
      #     start_period: "2025-Q1",
      #     end_period: "2025-Q2"
      #   )
      def quarterly(start_period:, end_period:)
        get_with_base_url(
          "#{BASE_URL}/QUARTERLY_REF_RATE/",
          start_period: start_period,
          end_period: end_period
        )
      end

      # Get annual weighted-average interbank exchange rate
      #
      # @param start_period [String] Start year in YYYY format (e.g., "2017")
      # @param end_period [String] End year in YYYY format (e.g., "2017")
      # @return [Hash] Response containing annual exchange rate data
      #
      # @example Get annual rates
      #   client.exchange_rate.annual(
      #     start_period: "2020",
      #     end_period: "2024"
      #   )
      def annual(start_period:, end_period:)
        get_with_base_url(
          "#{BASE_URL}/ANNUAL_REF_RATE/",
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
