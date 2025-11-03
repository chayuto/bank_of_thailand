# frozen_string_literal: true

require "spec_helper"

RSpec.describe BankOfThailand::Response do
  subject { described_class.new(mock_data) }

  let(:mock_data) do
    {
      "result" => {
        "data" => [
          { "period" => "2025-01-01", "value" => "33.5" },
          { "period" => "2025-01-02", "value" => "33.6" },
          { "period" => "2025-01-03", "value" => "33.4" },
          { "period" => "2025-01-04", "value" => "33.7" },
          { "period" => "2025-01-05", "value" => "33.3" }
        ]
      }
    }
  end

  let(:empty_data) { { "result" => { "data" => [] } } }

  describe "#initialize" do
    it "stores raw response" do
      expect(subject.raw).to eq(mock_data)
    end

    it "extracts data array" do
      expect(subject.data).to be_an(Array)
      expect(subject.data.size).to eq(5)
    end

    it "handles missing data" do
      response = described_class.new({})
      expect(response.data).to eq([])
    end
  end

  describe "#count" do
    it "returns number of data points" do
      expect(subject.count).to eq(5)
    end

    it "returns zero for empty data" do
      response = described_class.new(empty_data)
      expect(response.count).to eq(0)
    end
  end

  describe "#first" do
    it "returns first data point" do
      expect(subject.first).to eq({ "period" => "2025-01-01", "value" => "33.5" })
    end

    it "returns nil for empty data" do
      response = described_class.new(empty_data)
      expect(response.first).to be_nil
    end
  end

  describe "#last" do
    it "returns last data point" do
      expect(subject.last).to eq({ "period" => "2025-01-05", "value" => "33.3" })
    end

    it "returns nil for empty data" do
      response = described_class.new(empty_data)
      expect(response.last).to be_nil
    end
  end

  describe "#values_for" do
    it "extracts numeric values for a column" do
      values = subject.values_for("value")
      expect(values).to eq([33.5, 33.6, 33.4, 33.7, 33.3])
    end

    it "returns empty array for non-existent column" do
      expect(subject.values_for("nonexistent")).to eq([])
    end

    it "handles nil values" do
      data_with_nil = {
        "result" => {
          "data" => [
            { "value" => "10" },
            { "value" => nil },
            { "value" => "20" }
          ]
        }
      }
      response = described_class.new(data_with_nil)
      expect(response.values_for("value")).to eq([10.0, 20.0])
    end
  end

  describe "#min" do
    it "returns minimum value" do
      expect(subject.min("value")).to eq(33.3)
    end

    it "returns nil for empty data" do
      response = described_class.new(empty_data)
      expect(response.min("value")).to be_nil
    end
  end

  describe "#max" do
    it "returns maximum value" do
      expect(subject.max("value")).to eq(33.7)
    end

    it "returns nil for empty data" do
      response = described_class.new(empty_data)
      expect(response.max("value")).to be_nil
    end
  end

  describe "#sum" do
    it "returns sum of values" do
      expect(subject.sum("value")).to eq(167.5)
    end

    it "returns zero for empty data" do
      response = described_class.new(empty_data)
      expect(response.sum("value")).to eq(0)
    end
  end

  describe "#average" do
    it "calculates mean value" do
      expect(subject.average("value")).to eq(33.5)
    end

    it "returns zero for empty data" do
      response = described_class.new(empty_data)
      expect(response.average("value")).to eq(0.0)
    end

    it "can be called as mean" do
      expect(subject.mean("value")).to eq(33.5)
    end
  end

  describe "#date_range" do
    it "returns date range" do
      expect(subject.date_range).to eq(%w[2025-01-01 2025-01-05])
    end

    it "returns nil for empty data" do
      response = described_class.new(empty_data)
      expect(response.date_range).to be_nil
    end

    it "handles date field instead of period" do
      date_data = {
        "result" => {
          "data" => [
            { "date" => "2025-01-10" },
            { "date" => "2025-01-11" }
          ]
        }
      }
      response = described_class.new(date_data)
      expect(response.date_range).to eq(%w[2025-01-10 2025-01-11])
    end
  end

  describe "#period_days" do
    it "calculates number of days in period" do
      expect(subject.period_days).to eq(5)
    end

    it "returns zero for empty data" do
      response = described_class.new(empty_data)
      expect(response.period_days).to eq(0)
    end

    it "handles invalid dates gracefully" do
      invalid_data = {
        "result" => {
          "data" => [
            { "period" => "invalid" }
          ]
        }
      }
      response = described_class.new(invalid_data)
      expect(response.period_days).to eq(0)
    end
  end

  describe "#complete?" do
    it "returns true when all days are present" do
      expect(subject.complete?).to be true
    end

    it "returns false when days are missing" do
      incomplete_data = {
        "result" => {
          "data" => [
            { "period" => "2025-01-01" },
            { "period" => "2025-01-05" }
          ]
        }
      }
      response = described_class.new(incomplete_data)
      expect(response.complete?).to be false
    end

    it "returns true for empty data" do
      response = described_class.new(empty_data)
      expect(response.complete?).to be true
    end
  end

  describe "#missing_dates" do
    it "returns empty array when complete" do
      expect(subject.missing_dates).to eq([])
    end

    it "finds missing dates" do
      incomplete_data = {
        "result" => {
          "data" => [
            { "period" => "2025-01-01" },
            { "period" => "2025-01-03" },
            { "period" => "2025-01-05" }
          ]
        }
      }
      response = described_class.new(incomplete_data)
      missing = response.missing_dates
      expect(missing).to include(Date.parse("2025-01-02"))
      expect(missing).to include(Date.parse("2025-01-04"))
    end

    it "returns empty array for empty data" do
      response = described_class.new(empty_data)
      expect(response.missing_dates).to eq([])
    end

    it "handles invalid dates gracefully" do
      invalid_data = {
        "result" => {
          "data" => [{ "period" => "invalid" }]
        }
      }
      response = described_class.new(invalid_data)
      expect(response.missing_dates).to eq([])
    end
  end

  describe "#change" do
    it "calculates absolute and percentage change" do
      change = subject.change("value")
      expect(change[:absolute]).to be_within(0.01).of(-0.2)
      expect(change[:percentage]).to be_within(0.01).of(-0.5970)
      expect(change[:first_value]).to eq(33.5)
      expect(change[:last_value]).to eq(33.3)
    end

    it "returns nil for insufficient data" do
      single_data = {
        "result" => {
          "data" => [{ "value" => "10" }]
        }
      }
      response = described_class.new(single_data)
      expect(response.change("value")).to be_nil
    end

    it "returns nil for empty data" do
      response = described_class.new(empty_data)
      expect(response.change("value")).to be_nil
    end
  end

  describe "#daily_changes" do
    it "calculates changes between consecutive values" do
      changes = subject.daily_changes("value")
      expect(changes.size).to eq(4)
      expect(changes[0][:absolute]).to be_within(0.01).of(0.1)
      expect(changes[0][:percentage]).to be_within(0.01).of(0.2985)
    end

    it "returns empty array for insufficient data" do
      single_data = {
        "result" => {
          "data" => [{ "value" => "10" }]
        }
      }
      response = described_class.new(single_data)
      expect(response.daily_changes("value")).to eq([])
    end
  end

  describe "#volatility" do
    it "calculates standard deviation of daily changes" do
      volatility = subject.volatility("value")
      expect(volatility).to be > 0
      expect(volatility).to be_a(Float)
    end

    it "returns zero for insufficient data" do
      single_data = {
        "result" => {
          "data" => [{ "value" => "10" }]
        }
      }
      response = described_class.new(single_data)
      expect(response.volatility("value")).to eq(0.0)
    end

    it "returns zero for constant values" do
      constant_data = {
        "result" => {
          "data" => [
            { "value" => "10" },
            { "value" => "10" },
            { "value" => "10" }
          ]
        }
      }
      response = described_class.new(constant_data)
      expect(response.volatility("value")).to eq(0.0)
    end
  end

  describe "#trend" do
    it "returns :down when percentage change < -1" do
      expect(subject.trend("value")).to eq(:flat)
    end

    it "returns :up when percentage change > 1" do
      upward_data = {
        "result" => {
          "data" => [
            { "value" => "10" },
            { "value" => "11" }
          ]
        }
      }
      response = described_class.new(upward_data)
      expect(response.trend("value")).to eq(:up)
    end

    it "returns :flat when percentage change between -1 and 1" do
      flat_data = {
        "result" => {
          "data" => [
            { "value" => "100" },
            { "value" => "100.5" }
          ]
        }
      }
      response = described_class.new(flat_data)
      expect(response.trend("value")).to eq(:flat)
    end

    it "returns :flat for insufficient data" do
      single_data = {
        "result" => {
          "data" => [{ "value" => "10" }]
        }
      }
      response = described_class.new(single_data)
      expect(response.trend("value")).to eq(:flat)
    end
  end

  describe "#to_csv" do
    it "generates CSV string" do
      csv = subject.to_csv
      expect(csv).to be_a(String)
      expect(csv).to include("period,value")
      expect(csv).to include("2025-01-01,33.5")
    end

    it "writes to file when filename provided" do
      filename = "/tmp/test_output.csv"
      result = subject.to_csv(filename)
      expect(result).to eq(filename)
      expect(File.exist?(filename)).to be true
      File.delete(filename)
    end

    it "handles empty data" do
      response = described_class.new(empty_data)
      csv = response.to_csv
      expect(csv).to eq("\n")
    end

    it "handles array data" do
      array_data = {
        "result" => {
          "data" => [
            [1, 2, 3],
            [4, 5, 6]
          ]
        }
      }
      response = described_class.new(array_data)
      csv = response.to_csv
      expect(csv).to include("column_1,column_2,column_3")
      expect(csv).to include("1,2,3")
    end

    it "handles scalar data" do
      scalar_data = {
        "result" => {
          "data" => [1, 2, 3]
        }
      }
      response = described_class.new(scalar_data)
      csv = response.to_csv
      expect(csv).to include("value")
      expect(csv).to include("1")
    end
  end
end
