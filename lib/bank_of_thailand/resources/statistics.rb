# frozen_string_literal: true

module BankOfThailand
  module Resources
    # BOT License Check Public API
    #
    # API for checking licenses or registrations for businesses under the supervision
    # of the Bank of Thailand, such as P-Loan, Nano Finance, e-Money.
    #
    # @see https://gateway.api.bot.or.th/BotLicenseCheckAPI/
    class LicenseCheck < Resource
      # Base URL for this API (overrides the global base URL)
      BASE_URL = "https://gateway.api.bot.or.th/BotLicenseCheckAPI"

      # Search for authorized entities
      #
      # @param keyword [String] Search keyword (required)
      # @param page [String, Integer, nil] Page position (optional)
      # @param limit [Integer, nil] Number of results (optional)
      # @return [Hash] Response containing search results
      #
      # @example Search for authorized entities
      #   client.license_check.search_authorized(keyword: "finance")
      #
      # @example Search with pagination
      #   client.license_check.search_authorized(
      #     keyword: "finance",
      #     page: 1,
      #     limit: 10
      #   )
      def search_authorized(keyword:, page: nil, limit: nil)
        params = { keyword: keyword }
        params[:page] = page if page
        params[:limit] = limit if limit

        get_with_base_url("#{BASE_URL}/SearchAuthorized", params)
      end

      # Get license details
      #
      # @param auth_id [String] ID of the authorized entity in the system (required)
      # @param doc_id [String] Document reference number (required)
      # @return [Hash] Response containing license details
      #
      # @example Get license information
      #   client.license_check.license(
      #     auth_id: "12345",
      #     doc_id: "DOC-001"
      #   )
      def license(auth_id:, doc_id:)
        get_with_base_url(
          "#{BASE_URL}/License",
          authId: auth_id,
          docId: doc_id
        )
      end

      # Get authorized entity details
      #
      # @param id [Integer] ID of the authorized entity in the system (required)
      # @return [Hash] Response containing entity details
      #
      # @example Get entity details
      #   client.license_check.authorized_detail(id: 12345)
      def authorized_detail(id:)
        get_with_base_url("#{BASE_URL}/AuthorizedDetail", id: id)
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
