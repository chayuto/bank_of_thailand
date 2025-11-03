# frozen_string_literal: true

require "spec_helper"

RSpec.describe BankOfThailand::Configuration do
  describe "#initialize" do
    it "sets default values" do
      config = described_class.new

      expect(config.api_token).to be_nil
      expect(config.base_url).to eq("https://gateway.api.bot.or.th")
      expect(config.timeout).to eq(30)
      expect(config.max_retries).to eq(3)
      expect(config.logger).to be_nil
    end
  end

  describe "#validate!" do
    it "raises error when api_token is nil" do
      config = described_class.new

      expect { config.validate! }.to raise_error(
        BankOfThailand::ConfigurationError,
        "API token is required"
      )
    end

    it "raises error when api_token is empty" do
      config = described_class.new
      config.api_token = ""

      expect { config.validate! }.to raise_error(
        BankOfThailand::ConfigurationError,
        "API token is required"
      )
    end

    it "raises error when base_url is nil" do
      config = described_class.new
      config.api_token = "test_token"
      config.base_url = nil

      expect { config.validate! }.to raise_error(
        BankOfThailand::ConfigurationError,
        "Base URL cannot be empty"
      )
    end

    it "returns true when configuration is valid" do
      config = described_class.new
      config.api_token = "test_token"

      expect(config.validate!).to be true
    end
  end

  describe "#valid?" do
    it "returns false when configuration is invalid" do
      config = described_class.new

      expect(config.valid?).to be false
    end

    it "returns true when configuration is valid" do
      config = described_class.new
      config.api_token = "test_token"

      expect(config.valid?).to be true
    end
  end
end

RSpec.describe BankOfThailand do
  describe ".configuration" do
    it "returns a Configuration instance" do
      expect(described_class.configuration).to be_a(BankOfThailand::Configuration)
    end

    it "memoizes the configuration" do
      expect(described_class.configuration).to be(described_class.configuration)
    end
  end

  describe ".configure" do
    it "yields the configuration" do
      described_class.configure do |config|
        config.api_token = "test_token"
        config.timeout = 60
      end

      expect(described_class.configuration.api_token).to eq("test_token")
      expect(described_class.configuration.timeout).to eq(60)
    end
  end

  describe ".reset_configuration!" do
    it "resets configuration to defaults" do
      described_class.configure do |config|
        config.api_token = "test_token"
        config.timeout = 60
      end

      described_class.reset_configuration!

      expect(described_class.configuration.api_token).to be_nil
      expect(described_class.configuration.timeout).to eq(30)
    end
  end

  describe ".client" do
    before do
      described_class.configure do |config|
        config.api_token = "test_token"
      end
    end

    it "creates a new client instance" do
      client = described_class.client

      expect(client).to be_a(BankOfThailand::Client)
    end

    it "accepts a configuration block" do
      client = described_class.client do |config|
        config.timeout = 60
      end

      expect(client.config.timeout).to eq(60)
    end
  end
end
