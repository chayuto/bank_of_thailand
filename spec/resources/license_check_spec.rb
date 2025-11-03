# frozen_string_literal: true

require "spec_helper"

RSpec.describe BankOfThailand::Resources::LicenseCheck do
  let(:config) do
    BankOfThailand::Configuration.new.tap do |c|
      c.api_token = "test_token"
    end
  end

  let(:client) { BankOfThailand::Client.new(config) }
  let(:resource) { client.license_check }

  describe "#search_authorized" do
    let(:response_data) do
      {
        "results" => [
          {
            "id" => 1,
            "name" => "Example Finance Company",
            "license_type" => "P-Loan"
          }
        ]
      }
    end

    it "searches for authorized entities" do
      stub = stub_request(:get, "https://gateway.api.bot.or.th/BotLicenseCheckAPI/SearchAuthorized")
             .with(
               query: { keyword: "finance" },
               headers: { "Authorization" => "test_token" }
             )
             .to_return(
               status: 200,
               body: response_data.to_json,
               headers: { "Content-Type" => "application/json" }
             )

      result = resource.search_authorized(keyword: "finance")

      expect(result).to be_a(BankOfThailand::Response)
      expect(result.raw).to eq(response_data)
      expect(stub).to have_been_requested
    end

    it "accepts pagination parameters" do
      stub = stub_request(:get, "https://gateway.api.bot.or.th/BotLicenseCheckAPI/SearchAuthorized")
             .with(
               query: { keyword: "finance", page: "1", limit: 10 },
               headers: { "Authorization" => "test_token" }
             )
             .to_return(
               status: 200,
               body: response_data.to_json,
               headers: { "Content-Type" => "application/json" }
             )

      result = resource.search_authorized(keyword: "finance", page: 1, limit: 10)

      expect(result).to be_a(BankOfThailand::Response)
      expect(result.raw).to eq(response_data)
      expect(stub).to have_been_requested
    end
  end

  describe "#license" do
    let(:response_data) do
      {
        "license" => {
          "auth_id" => "12345",
          "doc_id" => "DOC-001",
          "status" => "active"
        }
      }
    end

    it "fetches license details" do
      stub = stub_request(:get, "https://gateway.api.bot.or.th/BotLicenseCheckAPI/License")
             .with(
               query: { authId: "12345", docId: "DOC-001" },
               headers: { "Authorization" => "test_token" }
             )
             .to_return(
               status: 200,
               body: response_data.to_json,
               headers: { "Content-Type" => "application/json" }
             )

      result = resource.license(auth_id: "12345", doc_id: "DOC-001")

      expect(result).to be_a(BankOfThailand::Response)
      expect(result.raw).to eq(response_data)
      expect(stub).to have_been_requested
    end
  end

  describe "#authorized_detail" do
    let(:response_data) do
      {
        "entity" => {
          "id" => 12_345,
          "name" => "Example Company",
          "licenses" => []
        }
      }
    end

    it "fetches authorized entity details" do
      stub = stub_request(:get, "https://gateway.api.bot.or.th/BotLicenseCheckAPI/AuthorizedDetail")
             .with(
               query: { id: 12_345 },
               headers: { "Authorization" => "test_token" }
             )
             .to_return(
               status: 200,
               body: response_data.to_json,
               headers: { "Content-Type" => "application/json" }
             )

      result = resource.authorized_detail(id: 12_345)

      expect(result).to be_a(BankOfThailand::Response)
      expect(result.raw).to eq(response_data)
      expect(stub).to have_been_requested
    end
  end
end
