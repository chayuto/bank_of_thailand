# frozen_string_literal: true

RSpec.describe BankOfThailand::FinancialHolidays do
  let(:client) { BankOfThailand::Client.new { |c| c.api_token = "test_token" } }
  let(:resource) { described_class.new(client) }

  describe "#list" do
    it "fetches financial institutions holidays" do
      stub_request(:get, "https://gateway.api.bot.or.th/financial-institutions-holidays/")
        .with(query: { year: "2024" })
        .to_return(
          status: 200,
          body: [
            {
              "HolidayWeekDay" => "Monday",
              "HolidayWeekDayThai" => "วันจันทร์",
              "Date" => "2024-01-01",
              "DateThai" => "01/01/2567",
              "HolidayDescription" => "New Year's Day",
              "HolidayDescriptionThai" => "วันขึ้นปีใหม่"
            }
          ].to_json
        )

      response = resource.list(year: "2024")
      expect(response).to be_a(BankOfThailand::Response)
      expect(response.data).to be_an(Array)
      expect(response.data.first["HolidayDescription"]).to eq("New Year's Day")
    end
  end
end
