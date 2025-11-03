# frozen_string_literal: true

module BankOfThailand
  # Loan Interest Rates resource
  #
  # This resource provides access to loan interest rates from commercial banks in Thailand.
  #
  # @example Get loan rates
  #   client = BankOfThailand.client
  #   rates = client.loan_rate.rates(
  #     start_period: "2024-01-01",
  #     end_period: "2024-01-31"
  #   )
  class LoanRate < Resource
    BASE_URL = "https://gateway.api.bot.or.th/LoanRate/v2"

    # Get loan interest rates of commercial banks
    #
    # @param start_period [String] Start period date (YYYY-MM-DD)
    # @param end_period [String] End period date (YYYY-MM-DD)
    # @return [Hash] Response containing loan interest rate data
    # @raise [BankOfThailand::Error] if the request fails
    def rates(start_period:, end_period:)
      params = { start_period: start_period, end_period: end_period }
      get_with_base_url("/loan_rate/", params)
    end

    # Get average loan interest rates of commercial banks
    #
    # @param start_period [String] Start period date (YYYY-MM-DD)
    # @param end_period [String] End period date (YYYY-MM-DD)
    # @return [Hash] Response containing average loan interest rate data
    # @raise [BankOfThailand::Error] if the request fails
    def average_rates(start_period:, end_period:)
      params = { start_period: start_period, end_period: end_period }
      get_with_base_url("/avg_loan_rate/", params)
    end

    private

    def get_with_base_url(path, params = {})
      @client.get("#{BASE_URL}#{path}", params)
    end
  end
end
