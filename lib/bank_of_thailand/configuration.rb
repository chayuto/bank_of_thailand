# frozen_string_literal: true

module BankOfThailand
  # Configuration for the BankOfThailand API client
  class Configuration
    # @return [String] API token for authentication
    attr_accessor :api_token

    # @return [String] Base URL for the BOT API gateway
    attr_accessor :base_url

    # @return [Integer] Request timeout in seconds
    attr_accessor :timeout

    # @return [Integer] Number of retry attempts for failed requests
    attr_accessor :max_retries

    # @return [Logger, nil] Logger instance for debugging
    attr_accessor :logger

    # Default base URL for the BOT API
    DEFAULT_BASE_URL = "https://gateway.api.bot.or.th"

    # Default timeout in seconds
    DEFAULT_TIMEOUT = 30

    # Default number of retries
    DEFAULT_MAX_RETRIES = 3

    # Initialize a new Configuration instance
    def initialize
      @api_token = nil
      @base_url = DEFAULT_BASE_URL
      @timeout = DEFAULT_TIMEOUT
      @max_retries = DEFAULT_MAX_RETRIES
      @logger = nil
    end

    # Validate the configuration
    # @raise [ConfigurationError] if configuration is invalid
    # @return [Boolean] true if valid
    def validate!
      raise ConfigurationError, "API token is required" if api_token.nil? || api_token.empty?
      raise ConfigurationError, "Base URL cannot be empty" if base_url.nil? || base_url.empty?

      true
    end

    # Check if configuration is valid
    # @return [Boolean] true if valid, false otherwise
    def valid?
      validate!
      true
    rescue ConfigurationError
      false
    end
  end

  class << self
    # @return [Configuration] the global configuration instance
    attr_writer :configuration

    # Get the global configuration
    # @return [Configuration] the configuration instance
    def configuration
      @configuration ||= Configuration.new
    end

    # Configure the gem
    # @yield [Configuration] the configuration instance
    # @return [void]
    #
    # @example
    #   BankOfThailand.configure do |config|
    #     config.api_token = "your_token_here"
    #     config.timeout = 60
    #   end
    def configure
      yield(configuration)
    end

    # Reset configuration to defaults
    # @return [Configuration] new configuration instance
    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
