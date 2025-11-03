# frozen_string_literal: true

module BankOfThailand
  # Swap Point - Onshore resource
  #
  # This resource provides access to swap point data for onshore transactions in Thailand.
  #
  # @example Get swap points
  #   client = BankOfThailand.client
  #   data = client.swap_point.rates(
  #     start_period: "2024-01-01",
  #     end_period: "2024-01-31",
  #     term_type: "1 Month"
  #   )
  class SwapPoint < Resource
    BASE_URL = "https://gateway.api.bot.or.th/Stat-SwapPoint/v2/SWAPPOINT"

    # Get swap point onshore rates
    #
    # @param start_period [String] Start period date (YYYY-MM-DD)
    # @param end_period [String] End period date (YYYY-MM-DD)
    # @param term_type [String, nil] Term type (e.g., "1 Month", "3 Month", "6 Month") (optional)
    # @return [Hash] Response containing swap point data
    # @raise [BankOfThailand::Error] if the request fails
    def rates(start_period:, end_period:, term_type: nil)
      params = { start_period: start_period, end_period: end_period }
      params[:term_type] = term_type if term_type

      get_with_base_url("/", params)
    end

    private

    def get_with_base_url(path, params = {})
      @client.get("#{BASE_URL}#{path}", params)
    end
  end
end
