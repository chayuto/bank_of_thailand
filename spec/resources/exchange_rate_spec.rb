# frozen_string_literal: true

require "spec_helper"

RSpec.describe BankOfThailand::Resources::ExchangeRate do
  let(:config) do
    BankOfThailand::Configuration.new.tap do |c|
      c.api_token = "test_token"
    end
  end

  let(:client) { BankOfThailand::Client.new(config) }
  let(:resource) { client.exchange_rate }

  describe "#daily" do
    let(:response_data) do
      {
        "result" => {
          "api" => "Daily Weighted-average Interbank Exchange Rate - THB / USD",
          "timestamp" => "2017-07-07 17:14:28",
          "data" => {
            "data_header" => {
              "report_name_eng" => "Rates of Exchange of Commercial Banks in Bangkok Metropolis (2002-present)",
              "last_updated" => "2017-06-13"
            },
            "data_detail" => [
              {
                "period" => "2002-01-15",
                "rate" => "43.9200000"
              },
              {
                "period" => "2002-01-14",
                "rate" => "43.9230000"
              }
            ]
          }
        }
      }
    end

    it "fetches daily exchange rates" do
      stub = stub_request(:get, "https://gateway.api.bot.or.th/Stat-ReferenceRate/v2/DAILY_REF_RATE/")
             .with(
               query: { start_period: "2025-01-01", end_period: "2025-01-31" },
               headers: { "Authorization" => "test_token" }
             )
             .to_return(
               status: 200,
               body: response_data.to_json,
               headers: { "Content-Type" => "application/json" }
             )

      result = resource.daily(start_period: "2025-01-01", end_period: "2025-01-31")

      expect(result).to eq(response_data)
      expect(stub).to have_been_requested
    end
  end

  describe "#monthly" do
    let(:response_data) do
      {
        "result" => {
          "api" => "Monthly Weighted-average Interbank Exchange Rate - THB / USD",
          "timestamp" => "2017-07-07 17:26:37",
          "data" => {
            "data_detail" => [
              {
                "period" => "2002-01",
                "rate" => "44.0215000"
              }
            ]
          }
        }
      }
    end

    it "fetches monthly exchange rates" do
      stub = stub_request(:get, "https://gateway.api.bot.or.th/Stat-ReferenceRate/v2/MONTHLY_REF_RATE/")
             .with(
               query: { start_period: "2025-01", end_period: "2025-03" },
               headers: { "Authorization" => "test_token" }
             )
             .to_return(
               status: 200,
               body: response_data.to_json,
               headers: { "Content-Type" => "application/json" }
             )

      result = resource.monthly(start_period: "2025-01", end_period: "2025-03")

      expect(result).to eq(response_data)
      expect(stub).to have_been_requested
    end
  end

  describe "#quarterly" do
    let(:response_data) do
      {
        "result" => {
          "api" => "Quarterly Weighted-average Interbank Exchange Rate - THB / USD",
          "data" => {
            "data_detail" => [
              {
                "period" => "2002-Q1",
                "rate" => "43.7432000"
              }
            ]
          }
        }
      }
    end

    it "fetches quarterly exchange rates" do
      stub = stub_request(:get, "https://gateway.api.bot.or.th/Stat-ReferenceRate/v2/QUARTERLY_REF_RATE/")
             .with(
               query: { start_period: "2025-Q1", end_period: "2025-Q2" },
               headers: { "Authorization" => "test_token" }
             )
             .to_return(
               status: 200,
               body: response_data.to_json,
               headers: { "Content-Type" => "application/json" }
             )

      result = resource.quarterly(start_period: "2025-Q1", end_period: "2025-Q2")

      expect(result).to eq(response_data)
      expect(stub).to have_been_requested
    end
  end

  describe "#annual" do
    let(:response_data) do
      {
        "result" => {
          "api" => "Annual Weighted-average Interbank Exchange Rate - THB / USD",
          "data" => {
            "data_detail" => [
              {
                "period" => "2002",
                "rate" => "43.0041000"
              }
            ]
          }
        }
      }
    end

    it "fetches annual exchange rates" do
      stub = stub_request(:get, "https://gateway.api.bot.or.th/Stat-ReferenceRate/v2/ANNUAL_REF_RATE/")
             .with(
               query: { start_period: "2020", end_period: "2024" },
               headers: { "Authorization" => "test_token" }
             )
             .to_return(
               status: 200,
               body: response_data.to_json,
               headers: { "Content-Type" => "application/json" }
             )

      result = resource.annual(start_period: "2020", end_period: "2024")

      expect(result).to eq(response_data)
      expect(stub).to have_been_requested
    end
  end
end
