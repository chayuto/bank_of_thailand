# frozen_string_literal: true

require "spec_helper"

RSpec.describe BankOfThailand::Client do
  let(:config) do
    BankOfThailand::Configuration.new.tap do |c|
      c.api_token = "test_token_123"
    end
  end

  let(:client) { described_class.new(config) }

  describe "#initialize" do
    it "sets the configuration" do
      expect(client.config).to eq(config)
    end

    it "validates configuration on initialization" do
      invalid_config = BankOfThailand::Configuration.new

      expect do
        described_class.new(invalid_config)
      end.to raise_error(BankOfThailand::ConfigurationError)
    end

    it "accepts a configuration block" do
      client = described_class.new do |c|
        c.api_token = "block_token"
      end

      expect(client.config.api_token).to eq("block_token")
    end
  end

  describe "#exchange_rate" do
    it "returns an ExchangeRate resource" do
      expect(client.exchange_rate).to be_a(BankOfThailand::Resources::ExchangeRate)
    end

    it "memoizes the resource" do
      expect(client.exchange_rate).to be(client.exchange_rate)
    end
  end

  describe "#debt_securities" do
    it "returns a DebtSecurities resource" do
      expect(client.debt_securities).to be_a(BankOfThailand::Resources::DebtSecurities)
    end
  end

  describe "#license_check" do
    it "returns a LicenseCheck resource" do
      expect(client.license_check).to be_a(BankOfThailand::Resources::LicenseCheck)
    end
  end

  describe "#average_exchange_rate" do
    it "returns an AverageExchangeRate resource" do
      expect(client.average_exchange_rate).to be_a(BankOfThailand::AverageExchangeRate)
    end
  end

  describe "#deposit_rate" do
    it "returns a DepositRate resource" do
      expect(client.deposit_rate).to be_a(BankOfThailand::DepositRate)
    end
  end

  describe "#financial_holidays" do
    it "returns a FinancialHolidays resource" do
      expect(client.financial_holidays).to be_a(BankOfThailand::FinancialHolidays)
    end
  end

  describe "#interbank_rate" do
    it "returns an InterbankRate resource" do
      expect(client.interbank_rate).to be_a(BankOfThailand::InterbankRate)
    end
  end

  describe "#loan_rate" do
    it "returns a LoanRate resource" do
      expect(client.loan_rate).to be_a(BankOfThailand::LoanRate)
    end
  end

  describe "#swap_point" do
    it "returns a SwapPoint resource" do
      expect(client.swap_point).to be_a(BankOfThailand::SwapPoint)
    end
  end

  describe "#implied_rate" do
    it "returns an ImpliedRate resource" do
      expect(client.implied_rate).to be_a(BankOfThailand::ImpliedRate)
    end
  end

  describe "#search_series" do
    it "returns a SearchSeries resource" do
      expect(client.search_series).to be_a(BankOfThailand::SearchSeries)
    end
  end

  describe "#get" do
    it "makes a GET request with authorization header" do
      stub = stub_request(:get, "https://gateway.api.bot.or.th/test/path")
             .with(headers: { "Authorization" => "test_token_123" })
             .to_return(
               status: 200,
               body: { data: "test" }.to_json,
               headers: { "Content-Type" => "application/json" }
             )

      result = client.get("/test/path")

      expect(result).to be_a(BankOfThailand::Response)
      expect(result.raw).to eq({ "data" => "test" })
      expect(stub).to have_been_requested
    end

    it "supports full URLs" do
      stub = stub_request(:get, "https://custom.api.example.com/endpoint")
             .with(headers: { "Authorization" => "test_token_123" })
             .to_return(
               status: 200,
               body: { data: "test" }.to_json,
               headers: { "Content-Type" => "application/json" }
             )

      result = client.get("https://custom.api.example.com/endpoint")

      expect(result).to be_a(BankOfThailand::Response)
      expect(result.raw).to eq({ "data" => "test" })
      expect(stub).to have_been_requested
    end

    it "includes query parameters" do
      stub = stub_request(:get, "https://gateway.api.bot.or.th/test/path")
             .with(
               query: { date: "2025-01-01" },
               headers: { "Authorization" => "test_token_123" }
             )
             .to_return(
               status: 200,
               body: { data: "test" }.to_json,
               headers: { "Content-Type" => "application/json" }
             )

      client.get("/test/path", { date: "2025-01-01" })

      expect(stub).to have_been_requested
    end

    it "raises AuthenticationError on 401" do
      stub_request(:get, "https://gateway.api.bot.or.th/test/path")
        .to_return(status: 401)

      expect do
        client.get("/test/path")
      end.to raise_error(BankOfThailand::AuthenticationError, /Authentication failed/)
    end

    it "raises AuthenticationError on 403" do
      stub_request(:get, "https://gateway.api.bot.or.th/test/path")
        .to_return(status: 403)

      expect do
        client.get("/test/path")
      end.to raise_error(BankOfThailand::AuthenticationError, /Access forbidden/)
    end

    it "raises NotFoundError on 404" do
      stub_request(:get, "https://gateway.api.bot.or.th/test/path")
        .to_return(status: 404)

      expect do
        client.get("/test/path")
      end.to raise_error(BankOfThailand::NotFoundError, /Resource not found/)
    end

    it "raises RateLimitError on 429" do
      stub_request(:get, "https://gateway.api.bot.or.th/test/path")
        .to_return(
          status: 429,
          headers: { "Retry-After" => "60" }
        )

      expect do
        client.get("/test/path")
      end.to raise_error(BankOfThailand::RateLimitError) do |error|
        expect(error.retry_after).to eq(60)
      end
    end

    it "raises ServerError on 500" do
      stub_request(:get, "https://gateway.api.bot.or.th/test/path")
        .to_return(status: 500)

      expect do
        client.get("/test/path")
      end.to raise_error(BankOfThailand::ServerError, /Server error/)
    end
  end

  describe "#post" do
    it "makes a POST request with body" do
      stub = stub_request(:post, "https://gateway.api.bot.or.th/test/path")
             .with(
               body: { key: "value" }.to_json,
               headers: {
                 "Authorization" => "test_token_123",
                 "Content-Type" => "application/json"
               }
             )
             .to_return(
               status: 200,
               body: { result: "success" }.to_json,
               headers: { "Content-Type" => "application/json" }
             )

      result = client.post("/test/path", body: { key: "value" })

      expect(result).to be_a(BankOfThailand::Response)
      expect(result.raw).to eq({ "result" => "success" })
      expect(stub).to have_been_requested
    end
  end
end
