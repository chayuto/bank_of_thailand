# frozen_string_literal: true

module BankOfThailand
  # Financial Institutions' Holidays resource
  #
  # This resource provides access to the list of holidays for financial institutions in Thailand.
  #
  # @example Get holidays for a year
  #   client = BankOfThailand.client
  #   holidays = client.financial_holidays.list(year: "2024")
  class FinancialHolidays < Resource
    BASE_URL = "https://gateway.api.bot.or.th/financial-institutions-holidays"

    # Get financial institutions' holidays for a specific year
    #
    # @param year [String] Year in format YYYY (e.g., "2024")
    # @return [Array<Hash>] Array of holiday data
    # @raise [BankOfThailand::Error] if the request fails
    def list(year:)
      params = { year: year }
      get_with_base_url("/", params)
    end

    private

    def get_with_base_url(path, params = {})
      @client.get("#{BASE_URL}#{path}", params)
    end
  end
end
