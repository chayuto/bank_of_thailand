# frozen_string_literal: true

RSpec.describe BankOfThailand::InterbankRate do
  let(:client) { BankOfThailand::Client.new { |c| c.api_token = "test_token" } }
  let(:resource) { described_class.new(client) }

  describe "#rates" do
    it "fetches interbank transaction rates" do
      stub_request(:get, "https://gateway.api.bot.or.th/Stat-InterbankTransactionRate/v2/INTRBNK_TXN_RATE/")
        .with(query: { start_period: "2024-01-01", end_period: "2024-01-31" })
        .to_return(
          status: 200,
          body: {
            result: {
              api: "Interbank Transaction Rates (Percent per annum)",
              data: { data_detail: [] }
            }
          }.to_json
        )

      response = resource.rates(start_period: "2024-01-01", end_period: "2024-01-31")
      expect(response["result"]["api"]).to eq("Interbank Transaction Rates (Percent per annum)")
    end

    it "accepts term_type parameter" do
      stub_request(:get, "https://gateway.api.bot.or.th/Stat-InterbankTransactionRate/v2/INTRBNK_TXN_RATE/")
        .with(query: { start_period: "2024-01-01", end_period: "2024-01-31", term_type: "O/N" })
        .to_return(status: 200, body: { result: {} }.to_json)

      resource.rates(start_period: "2024-01-01", end_period: "2024-01-31", term_type: "O/N")
      expect(WebMock).to have_requested(:get, /INTRBNK_TXN_RATE/).with(query: hash_including("term_type" => "O/N"))
    end
  end
end
