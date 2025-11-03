# frozen_string_literal: true

module BankOfThailand
  # Search Stat APIs resource
  #
  # This resource allows users to search for data in BOT API Statistics by keyword search
  # using series code, series name, or relevant terms. The result will be displayed up to
  # 100 series per search.
  #
  # @example Search for series
  #   client = BankOfThailand.client
  #   results = client.search_series.search(keyword: "government debt")
  class SearchSeries < Resource
    BASE_URL = "https://gateway.api.bot.or.th/search-series"

    # Search for series by keyword
    #
    # @param keyword [String] Keyword for search series (required)
    # @return [Hash] Response containing series details
    # @raise [BankOfThailand::Error] if the request fails
    #
    # @example Search for series
    #   client.search_series.search(keyword: "government debt")
    #
    # @note Returns up to 100 series per search
    def search(keyword:)
      params = { keyword: keyword }
      get_with_base_url("/", params)
    end

    private

    def get_with_base_url(path, params = {})
      @client.get("#{BASE_URL}#{path}", params)
    end
  end
end
