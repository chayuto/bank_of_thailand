# frozen_string_literal: true

require "spec_helper"

RSpec.describe BankOfThailand::Resources::DebtSecurities do
  let(:config) do
    BankOfThailand::Configuration.new.tap do |c|
      c.api_token = "test_token"
    end
  end

  let(:client) { BankOfThailand::Client.new(config) }
  let(:resource) { client.debt_securities }

  describe "#auction_results" do
    let(:response_data) do
      {
        "result" => {
          "api" => "Bond Auction",
          "timestamp" => "2017-10-03 08:53:51",
          "data" => {
            "data_detail" => [
              {
                "auction_date" => "2017-09-26",
                "debt_securities_type" => "Government Bonds",
                "thaibma_symbol" => "LB233A",
                "isin_code" => "TH0623033303",
                "cfi_code" => "DBFTFR",
                "coupon_rate" => "5.5",
                "time_to_maturity" => "5.46 Yrs",
                "maturity_date" => "2023-03-13",
                "accepted_amount_ncb_cb" => "2000.0000000",
                "weighted_average_accepted_yield" => "1.7077000",
                "auction_st" => "Approve"
              }
            ]
          }
        }
      }
    end

    it "fetches auction results" do
      stub = stub_request(:get, "https://gateway.api.bot.or.th/BondAuction/bond_auction_v2/")
             .with(
               query: { start_period: "2025-01-01", end_period: "2025-01-31" },
               headers: { "Authorization" => "test_token" }
             )
             .to_return(
               status: 200,
               body: response_data.to_json,
               headers: { "Content-Type" => "application/json" }
             )

      result = resource.auction_results(start_period: "2025-01-01", end_period: "2025-01-31")

      expect(result).to eq(response_data)
      expect(stub).to have_been_requested
    end
  end
end
