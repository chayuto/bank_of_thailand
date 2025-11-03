# frozen_string_literal: true

RSpec.describe BankOfThailand::SearchSeries do
  let(:client) { BankOfThailand::Client.new { |c| c.api_token = "test_token" } }
  let(:resource) { described_class.new(client) }

  describe "#search" do
    it "searches for series by keyword" do
      stub_request(:get, "https://gateway.api.bot.or.th/search-series/")
        .with(query: { keyword: "government debt" })
        .to_return(
          status: 200,
          body: {
            result: {
              api: "Search Stat APIs",
              timestamp: "2024-01-01 10:00:00",
              series_details: [
                {
                  series_code: "PF00000000Q00232",
                  series_name_eng: "Government debt securities_Total",
                  frequency: "Quarterly"
                }
              ]
            }
          }.to_json
        )

      response = resource.search(keyword: "government debt")
      expect(response["result"]["api"]).to eq("Search Stat APIs")
      expect(response["result"]["series_details"]).to be_an(Array)
    end

    it "requires keyword parameter" do
      expect { resource.search }.to raise_error(ArgumentError)
    end
  end
end
