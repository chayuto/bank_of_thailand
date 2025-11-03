# frozen_string_literal: true

module BankOfThailand
  # Interbank Transaction Rates resource
  #
  # This resource provides access to interbank transaction rates from commercial banks
  # and financial institutions in Thailand.
  #
  # @example Get interbank rates
  #   client = BankOfThailand.client
  #   rates = client.interbank_rate.rates(
  #     start_period: "2024-01-01",
  #     end_period: "2024-01-31",
  #     term_type: "O/N"
  #   )
  class InterbankRate < Resource
    BASE_URL = "https://gateway.api.bot.or.th/Stat-InterbankTransactionRate/v2/INTRBNK_TXN_RATE"

    # Get interbank transaction rates
    #
    # @param start_period [String] Start period date (YYYY-MM-DD)
    # @param end_period [String] End period date (YYYY-MM-DD)
    # @param term_type [String, nil] Term type (e.g., "O/N", "T/N") (optional)
    # @return [Hash] Response containing interbank transaction rate data
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
