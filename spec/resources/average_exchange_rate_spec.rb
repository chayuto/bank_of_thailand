# frozen_string_literal: true

RSpec.describe BankOfThailand::AverageExchangeRate do
  let(:client) { BankOfThailand::Client.new { |c| c.api_token = "test_token" } }
  let(:resource) { described_class.new(client) }

  describe "#daily" do
    it "fetches daily average exchange rates" do
      stub_request(:get, "https://gateway.api.bot.or.th/Stat-ExchangeRate/v2/DAILY_AVG_EXG_RATE/")
        .with(query: { start_period: "2024-01-01", end_period: "2024-01-31" })
        .to_return(
          status: 200,
          body: {
            result: {
              api: "Daily Average Exchange Rate - THB / Foreign Currency",
              data: { data_detail: [{ period: "2024-01-01", currency_id: "USD" }] }
            }
          }.to_json
        )

      response = resource.daily(start_period: "2024-01-01", end_period: "2024-01-31")
      expect(response["result"]["api"]).to eq("Daily Average Exchange Rate - THB / Foreign Currency")
    end

    it "accepts currency parameter" do
      stub_request(:get, "https://gateway.api.bot.or.th/Stat-ExchangeRate/v2/DAILY_AVG_EXG_RATE/")
        .with(query: { start_period: "2024-01-01", end_period: "2024-01-31", currency: "USD" })
        .to_return(status: 200, body: { result: {} }.to_json)

      resource.daily(start_period: "2024-01-01", end_period: "2024-01-31", currency: "USD")
      expect(WebMock).to have_requested(:get, /DAILY_AVG_EXG_RATE/).with(query: hash_including("currency" => "USD"))
    end
  end

  describe "#monthly" do
    it "fetches monthly average exchange rates" do
      stub_request(:get, "https://gateway.api.bot.or.th/Stat-ExchangeRate/v2/MONTHLY_AVG_EXG_RATE/")
        .with(query: { start_period: "2024-01", end_period: "2024-12" })
        .to_return(
          status: 200,
          body: {
            result: {
              api: "Monthly Average Exchange Rate - THB / Foreign Currency",
              data: {}
            }
          }.to_json
        )

      response = resource.monthly(start_period: "2024-01", end_period: "2024-12")
      expect(response["result"]["api"]).to eq("Monthly Average Exchange Rate - THB / Foreign Currency")
    end
  end

  describe "#quarterly" do
    it "fetches quarterly average exchange rates" do
      stub_request(:get, "https://gateway.api.bot.or.th/Stat-ExchangeRate/v2/QUARTERLY_AVG_EXG_RATE/")
        .with(query: { start_period: "2024-Q1", end_period: "2024-Q4" })
        .to_return(
          status: 200,
          body: {
            result: {
              api: "Quarterly Average Exchange Rate - THB / Foreign Currency",
              data: {}
            }
          }.to_json
        )

      response = resource.quarterly(start_period: "2024-Q1", end_period: "2024-Q4")
      expect(response["result"]["api"]).to eq("Quarterly Average Exchange Rate - THB / Foreign Currency")
    end
  end

  describe "#annual" do
    it "fetches annual average exchange rates" do
      stub_request(:get, "https://gateway.api.bot.or.th/Stat-ExchangeRate/v2/ANNUAL_AVG_EXG_RATE/")
        .with(query: { start_period: "2023", end_period: "2024" })
        .to_return(
          status: 200,
          body: {
            result: {
              api: "Annual Average Exchange Rate - THB / Foreign Currency",
              data: {}
            }
          }.to_json
        )

      response = resource.annual(start_period: "2023", end_period: "2024")
      expect(response["result"]["api"]).to eq("Annual Average Exchange Rate - THB / Foreign Currency")
    end
  end
end
