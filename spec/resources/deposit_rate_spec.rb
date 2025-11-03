# frozen_string_literal: true

RSpec.describe BankOfThailand::DepositRate do
  let(:client) { BankOfThailand::Client.new { |c| c.api_token = "test_token" } }
  let(:resource) { described_class.new(client) }

  describe "#rates" do
    it "fetches deposit interest rates" do
      stub_request(:get, "https://gateway.api.bot.or.th/DepositRate/v2/deposit_rate/")
        .with(query: { start_period: "2024-01-01", end_period: "2024-01-31" })
        .to_return(
          status: 200,
          body: {
            result: {
              api: "Deposit Interest Rates for Individuals of Commercial Banks (Percent per annum)",
              data: { data_detail: [] }
            }
          }.to_json
        )

      response = resource.rates(start_period: "2024-01-01", end_period: "2024-01-31")
      expect(response["result"]["api"]).to include("Deposit Interest Rates")
    end
  end

  describe "#average_rates" do
    it "fetches min-max deposit interest rates" do
      stub_request(:get, "https://gateway.api.bot.or.th/DepositRate/v2/avg_deposit_rate/")
        .with(query: { start_period: "2024-01-01", end_period: "2024-01-31" })
        .to_return(
          status: 200,
          body: {
            result: {
              api: "Min-Max Deposit Interest Rates for Individuals of Commercial Banks (Percent per annum)",
              data: {}
            }
          }.to_json
        )

      response = resource.average_rates(start_period: "2024-01-01", end_period: "2024-01-31")
      expect(response["result"]["api"]).to include("Min-Max Deposit Interest Rates")
    end
  end
end
