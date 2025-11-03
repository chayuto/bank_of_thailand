# frozen_string_literal: true

RSpec.describe BankOfThailand::ImpliedRate do
  let(:client) { BankOfThailand::Client.new { |c| c.api_token = "test_token" } }
  let(:resource) { described_class.new(client) }

  describe "#rates" do
    it "fetches Thai Baht implied interest rates" do
      stub_request(:get, "https://gateway.api.bot.or.th/Stat-ThaiBahtImpliedInterestRate/v2/THB_IMPL_INT_RATE/")
        .with(query: { start_period: "2024-01-01", end_period: "2024-01-31" })
        .to_return(
          status: 200,
          body: {
            result: {
              api: "Thai Baht Implied Interest Rates (Percent per annum)",
              data: { data_detail: [] }
            }
          }.to_json
        )

      response = resource.rates(start_period: "2024-01-01", end_period: "2024-01-31")
      expect(response["result"]["api"]).to eq("Thai Baht Implied Interest Rates (Percent per annum)")
    end

    it "accepts rate_type parameter" do
      stub_request(:get, "https://gateway.api.bot.or.th/Stat-ThaiBahtImpliedInterestRate/v2/THB_IMPL_INT_RATE/")
        .with(query: { start_period: "2024-01-01", end_period: "2024-01-31", rate_type: "ONSHORE : T/N" })
        .to_return(status: 200, body: { result: {} }.to_json)

      resource.rates(start_period: "2024-01-01", end_period: "2024-01-31", rate_type: "ONSHORE : T/N")
      expect(WebMock).to have_requested(:get, /THB_IMPL_INT_RATE/).with(
        query: hash_including("rate_type" => "ONSHORE : T/N")
      )
    end
  end
end
