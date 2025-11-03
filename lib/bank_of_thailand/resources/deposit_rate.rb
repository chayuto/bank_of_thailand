# frozen_string_literal: true

module BankOfThailand
  # Deposit Interest Rates resource
  #
  # This resource provides access to deposit interest rates for individuals
  # from commercial banks in Thailand.
  #
  # @example Get deposit rates
  #   client = BankOfThailand.client
  #   rates = client.deposit_rate.rates(
  #     start_period: "2024-01-01",
  #     end_period: "2024-01-31"
  #   )
  class DepositRate < Resource
    BASE_URL = "https://gateway.api.bot.or.th/DepositRate/v2"

    # Get deposit interest rates for individuals of commercial banks
    #
    # @param start_period [String] Start period date (YYYY-MM-DD)
    # @param end_period [String] End period date (YYYY-MM-DD)
    # @return [Hash] Response containing deposit interest rate data
    # @raise [BankOfThailand::Error] if the request fails
    def rates(start_period:, end_period:)
      params = { start_period: start_period, end_period: end_period }
      get_with_base_url("/deposit_rate/", params)
    end

    # Get min-max deposit interest rates for individuals of commercial banks
    #
    # @param start_period [String] Start period date (YYYY-MM-DD)
    # @param end_period [String] End period date (YYYY-MM-DD)
    # @return [Hash] Response containing min-max deposit interest rate data
    # @raise [BankOfThailand::Error] if the request fails
    def average_rates(start_period:, end_period:)
      params = { start_period: start_period, end_period: end_period }
      get_with_base_url("/avg_deposit_rate/", params)
    end

    private

    def get_with_base_url(path, params = {})
      @client.get("#{BASE_URL}#{path}", params)
    end
  end
end
