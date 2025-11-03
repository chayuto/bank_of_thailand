# frozen_string_literal: true

require "faraday"
require "faraday/retry"
require "json"

module BankOfThailand
  # HTTP client for making requests to the BOT API
  class Client
    # @return [Configuration] the configuration instance
    attr_reader :config

    # Initialize a new Client
    # @param config [Configuration, nil] Optional configuration instance
    # @yield [Configuration] optional configuration block
    #
    # @example With global configuration
    #   client = BankOfThailand::Client.new
    #
    # @example With instance configuration
    #   client = BankOfThailand::Client.new do |config|
    #     config.api_token = "your_token"
    #   end
    def initialize(config = nil)
      @config = config || BankOfThailand.configuration.dup
      yield(@config) if block_given?
      @config.validate!
    end

    # Access exchange rate endpoints
    # @return [Resources::ExchangeRate]
    def exchange_rate
      @exchange_rate ||= Resources::ExchangeRate.new(self)
    end

    # Access debt securities auction endpoints
    # @return [Resources::DebtSecurities]
    def debt_securities
      @debt_securities ||= Resources::DebtSecurities.new(self)
    end

    # Access license check endpoints
    # @return [Resources::LicenseCheck]
    def license_check
      @license_check ||= Resources::LicenseCheck.new(self)
    end

    # Access average exchange rate endpoints
    # @return [AverageExchangeRate]
    def average_exchange_rate
      @average_exchange_rate ||= AverageExchangeRate.new(self)
    end

    # Access deposit rate endpoints
    # @return [DepositRate]
    def deposit_rate
      @deposit_rate ||= DepositRate.new(self)
    end

    # Access financial holidays endpoints
    # @return [FinancialHolidays]
    def financial_holidays
      @financial_holidays ||= FinancialHolidays.new(self)
    end

    # Access interbank rate endpoints
    # @return [InterbankRate]
    def interbank_rate
      @interbank_rate ||= InterbankRate.new(self)
    end

    # Access loan rate endpoints
    # @return [LoanRate]
    def loan_rate
      @loan_rate ||= LoanRate.new(self)
    end

    # Access swap point endpoints
    # @return [SwapPoint]
    def swap_point
      @swap_point ||= SwapPoint.new(self)
    end

    # Access implied rate endpoints
    # @return [ImpliedRate]
    def implied_rate
      @implied_rate ||= ImpliedRate.new(self)
    end

    # Access search series endpoints
    # @return [SearchSeries]
    def search_series
      @search_series ||= SearchSeries.new(self)
    end

    # Make a GET request
    # @param path [String] API endpoint path
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed JSON response
    # @raise [RequestError] if request fails
    def get(path, params = {})
      request(:get, path, params: params)
    end

    # Make a POST request
    # @param path [String] API endpoint path
    # @param body [Hash] Request body
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed JSON response
    # @raise [RequestError] if request fails
    def post(path, body: {}, params: {})
      request(:post, path, body: body, params: params)
    end

    private

    # Make an HTTP request
    # @param method [Symbol] HTTP method (:get, :post, etc.)
    # @param path [String] API endpoint path (can be full URL or relative path)
    # @param params [Hash] Query parameters
    # @param body [Hash] Request body
    # @return [Hash] Parsed response
    # @raise [RequestError] if request fails
    def request(method, path, params: {}, body: nil)
      # Determine if path is a full URL or relative path
      url = if path.start_with?("http://", "https://")
              path
            else
              "#{config.base_url}#{path}"
            end

      response = Faraday.send(method, url) do |req|
        req.headers["Authorization"] = config.api_token
        req.headers["Content-Type"] = "application/json"
        req.params = params if params.any?
        req.body = body.to_json if body
        req.options.timeout = config.timeout
        req.options.open_timeout = config.timeout
      end

      handle_response(response)
    rescue Faraday::TimeoutError => e
      raise RequestError, "Request timeout: #{e.message}"
    rescue Faraday::ConnectionFailed => e
      raise RequestError, "Connection failed: #{e.message}"
    rescue Faraday::Error => e
      raise RequestError, "Request failed: #{e.message}"
    end

    # Handle HTTP response
    # @param response [Faraday::Response] HTTP response
    # @return [Hash] Parsed response body
    # @raise [RequestError] if response indicates an error
    def handle_response(response)
      case response.status
      when 200..299
        parse_json(response.body)
      when 401
        raise AuthenticationError.new("Authentication failed. Check your API token.", response)
      when 403
        raise AuthenticationError.new(
          "Access forbidden. Your token may not have permission for this resource.",
          response
        )
      when 404
        raise NotFoundError.new("Resource not found: #{response.env.url}", response)
      when 429
        retry_after = response.headers["retry-after"]&.to_i
        raise RateLimitError.new("Rate limit exceeded", response, retry_after)
      when 500..599
        raise ServerError.new("Server error (#{response.status})", response)
      else
        raise RequestError.new("Unexpected response status: #{response.status}", response)
      end
    end

    # Parse JSON response
    # @param body [String] Response body
    # @return [Hash] Parsed JSON
    def parse_json(body)
      return {} if body.nil? || body.empty?

      JSON.parse(body)
    rescue JSON::ParserError => e
      raise RequestError, "Invalid JSON response: #{e.message}"
    end
  end
end
