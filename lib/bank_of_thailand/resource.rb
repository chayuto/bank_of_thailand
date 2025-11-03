# frozen_string_literal: true

module BankOfThailand
  # Base class for API resources
  class Resource
    # @return [Client] the API client instance
    attr_reader :client

    # Initialize a new Resource
    # @param client [Client] API client instance
    def initialize(client)
      @client = client
    end

    private

    # Make a GET request
    # @param path [String] API endpoint path
    # @param params [Hash] Query parameters
    # @return [Hash] Response data
    def get(path, params = {})
      client.get(path, params)
    end

    # Make a POST request
    # @param path [String] API endpoint path
    # @param body [Hash] Request body
    # @param params [Hash] Query parameters
    # @return [Hash] Response data
    def post(path, body: {}, params: {})
      client.post(path, body: body, params: params)
    end
  end
end
