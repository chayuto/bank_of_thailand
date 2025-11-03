# frozen_string_literal: true

module BankOfThailand
  # Thai Baht Implied Interest Rates resource
  #
  # This resource provides access to Thai Baht implied interest rates derived from
  # the swap market.
  #
  # @example Get implied interest rates
  #   client = BankOfThailand.client
  #   rates = client.implied_rate.rates(
  #     start_period: "2024-01-01",
  #     end_period: "2024-01-31",
  #     rate_type: "ONSHORE : T/N"
  #   )
  class ImpliedRate < Resource
    BASE_URL = "https://gateway.api.bot.or.th/Stat-ThaiBahtImpliedInterestRate/v2/THB_IMPL_INT_RATE"

    # Get Thai Baht implied interest rates
    #
    # @param start_period [String] Start period date (YYYY-MM-DD)
    # @param end_period [String] End period date (YYYY-MM-DD)
    # @param rate_type [String, nil] Rate type (e.g., "ONSHORE : T/N") (optional)
    # @return [Hash] Response containing Thai Baht implied interest rate data
    # @raise [BankOfThailand::Error] if the request fails
    def rates(start_period:, end_period:, rate_type: nil)
      params = { start_period: start_period, end_period: end_period }
      params[:rate_type] = rate_type if rate_type

      get_with_base_url("/", params)
    end

    private

    def get_with_base_url(path, params = {})
      @client.get("#{BASE_URL}#{path}", params)
    end
  end
end
