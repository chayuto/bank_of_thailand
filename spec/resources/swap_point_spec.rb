# frozen_string_literal: true

RSpec.describe BankOfThailand::SwapPoint do
  let(:client) { BankOfThailand::Client.new { |c| c.api_token = "test_token" } }
  let(:resource) { described_class.new(client) }

  describe "#rates" do
    it "fetches swap point onshore rates" do
      stub_request(:get, "https://gateway.api.bot.or.th/Stat-SwapPoint/v2/SWAPPOINT/")
        .with(query: { start_period: "2024-01-01", end_period: "2024-01-31" })
        .to_return(
          status: 200,
          body: {
            result: {
              api: "Swap point - Onshore (in Satangs)",
              data: { data_detail: [] }
            }
          }.to_json
        )

      response = resource.rates(start_period: "2024-01-01", end_period: "2024-01-31")
      expect(response["result"]["api"]).to eq("Swap point - Onshore (in Satangs)")
    end

    it "accepts term_type parameter" do
      stub_request(:get, "https://gateway.api.bot.or.th/Stat-SwapPoint/v2/SWAPPOINT/")
        .with(query: { start_period: "2024-01-01", end_period: "2024-01-31", term_type: "1 Month" })
        .to_return(status: 200, body: { result: {} }.to_json)

      resource.rates(start_period: "2024-01-01", end_period: "2024-01-31", term_type: "1 Month")
      expect(WebMock).to have_requested(:get, /SWAPPOINT/).with(query: hash_including("term_type" => "1 Month"))
    end
  end
end
