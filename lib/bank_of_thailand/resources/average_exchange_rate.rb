# frozen_string_literal: true

module BankOfThailand
  # Average Exchange Rate - THB / Foreign Currency resource
  #
  # This resource provides access to daily average exchange rates between Thai Baht
  # and 19 foreign currencies from commercial banks in Thailand.
  #
  # @example Get daily average exchange rates
  #   client = BankOfThailand.client
  #   rates = client.average_exchange_rate.daily(
  #     start_period: "2024-01-01",
  #     end_period: "2024-01-31",
  #     currency: "USD"
  #   )
  class AverageExchangeRate < Resource
    BASE_URL = "https://gateway.api.bot.or.th/Stat-ExchangeRate/v2"

    # Get daily average exchange rates
    #
    # @param start_period [String] Start period date (YYYY-MM-DD)
    # @param end_period [String] End period date (YYYY-MM-DD)
    # @param currency [String, nil] Foreign currency code (optional)
    # @return [Hash] Response containing daily average exchange rate data
    # @raise [BankOfThailand::Error] if the request fails
    def daily(start_period:, end_period:, currency: nil)
      params = { start_period: start_period, end_period: end_period }
      params[:currency] = currency if currency

      get_with_base_url("/DAILY_AVG_EXG_RATE/", params)
    end

    # Get monthly average exchange rates
    #
    # @param start_period [String] Start period (YYYY-MM)
    # @param end_period [String] End period (YYYY-MM)
    # @param currency [String, nil] Foreign currency code (optional)
    # @return [Hash] Response containing monthly average exchange rate data
    # @raise [BankOfThailand::Error] if the request fails
    def monthly(start_period:, end_period:, currency: nil)
      params = { start_period: start_period, end_period: end_period }
      params[:currency] = currency if currency

      get_with_base_url("/MONTHLY_AVG_EXG_RATE/", params)
    end

    # Get quarterly average exchange rates
    #
    # @param start_period [String] Start period (YYYY-QN, e.g., 2024-Q1)
    # @param end_period [String] End period (YYYY-QN)
    # @param currency [String, nil] Foreign currency code (optional)
    # @return [Hash] Response containing quarterly average exchange rate data
    # @raise [BankOfThailand::Error] if the request fails
    def quarterly(start_period:, end_period:, currency: nil)
      params = { start_period: start_period, end_period: end_period }
      params[:currency] = currency if currency

      get_with_base_url("/QUARTERLY_AVG_EXG_RATE/", params)
    end

    # Get annual average exchange rates
    #
    # @param start_period [String] Start period (YYYY)
    # @param end_period [String] End period (YYYY)
    # @param currency [String, nil] Foreign currency code (optional)
    # @return [Hash] Response containing annual average exchange rate data
    # @raise [BankOfThailand::Error] if the request fails
    def annual(start_period:, end_period:, currency: nil)
      params = { start_period: start_period, end_period: end_period }
      params[:currency] = currency if currency

      get_with_base_url("/ANNUAL_AVG_EXG_RATE/", params)
    end

    private

    def get_with_base_url(path, params = {})
      @client.get("#{BASE_URL}#{path}", params)
    end
  end
end
