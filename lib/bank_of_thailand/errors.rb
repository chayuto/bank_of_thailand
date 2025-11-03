# frozen_string_literal: true

module BankOfThailand
  # Base error class for all BankOfThailand errors
  class Error < StandardError; end

  # Raised when API request fails
  class RequestError < Error
    attr_reader :response

    # @param message [String] Error message
    # @param response [Faraday::Response, nil] HTTP response object
    def initialize(message, response = nil)
      @response = response
      super(message)
    end
  end

  # Raised when authentication fails
  class AuthenticationError < RequestError; end

  # Raised when the API token is missing or invalid
  class InvalidTokenError < AuthenticationError; end

  # Raised when the requested resource is not found
  class NotFoundError < RequestError; end

  # Raised when rate limit is exceeded
  class RateLimitError < RequestError
    attr_reader :retry_after

    # @param message [String] Error message
    # @param response [Faraday::Response, nil] HTTP response object
    # @param retry_after [Integer, nil] Seconds to wait before retrying
    def initialize(message, response = nil, retry_after = nil)
      @retry_after = retry_after
      super(message, response)
    end
  end

  # Raised when server returns 5xx error
  class ServerError < RequestError; end

  # Raised when configuration is invalid
  class ConfigurationError < Error; end
end
