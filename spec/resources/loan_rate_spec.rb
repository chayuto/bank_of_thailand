# frozen_string_literal: true

RSpec.describe BankOfThailand::LoanRate do
  let(:client) { BankOfThailand::Client.new { |c| c.api_token = "test_token" } }
  let(:resource) { described_class.new(client) }

  describe "#rates" do
    it "fetches loan interest rates" do
      stub_request(:get, "https://gateway.api.bot.or.th/LoanRate/v2/loan_rate/")
        .with(query: { start_period: "2024-01-01", end_period: "2024-01-31" })
        .to_return(
          status: 200,
          body: {
            result: {
              api: "Loan Interest Rates of Commercial Banks (Percent per annum)",
              data: { data_detail: [] }
            }
          }.to_json
        )

      response = resource.rates(start_period: "2024-01-01", end_period: "2024-01-31")
      expect(response["result"]["api"]).to include("Loan Interest Rates")
    end
  end

  describe "#average_rates" do
    it "fetches average loan interest rates" do
      stub_request(:get, "https://gateway.api.bot.or.th/LoanRate/v2/avg_loan_rate/")
        .with(query: { start_period: "2024-01-01", end_period: "2024-01-31" })
        .to_return(
          status: 200,
          body: {
            result: {
              api: "Average Loan Interest Rates of Commercial Banks (Percent per annum)",
              data: {}
            }
          }.to_json
        )

      response = resource.average_rates(start_period: "2024-01-01", end_period: "2024-01-31")
      expect(response["result"]["api"]).to include("Average Loan Interest Rates")
    end
  end
end
