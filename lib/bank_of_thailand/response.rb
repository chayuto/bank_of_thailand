# frozen_string_literal: true

require "csv"
require "date"

module BankOfThailand
  # Wrapper for API responses with convenience methods
  class Response
    # @return [Hash] the raw API response
    attr_reader :raw

    # @return [Array<Hash>] the extracted data array
    attr_reader :data

    # Initialize a new Response
    # @param raw_response [Hash] the raw API response
    def initialize(raw_response)
      @raw = raw_response
      @data = extract_data(raw_response)
    end

    # Allow hash-like access for backward compatibility
    # @param key [String, Symbol] the key to access
    # @return [Object] the value at the key
    def [](key)
      return nil unless raw.is_a?(Hash)

      raw[key.to_s]
    end

    # Allow hash-like dig for backward compatibility
    # @param keys [Array] the keys to dig through
    # @return [Object] the value at the nested keys
    def dig(*keys)
      return nil unless raw.is_a?(Hash)

      raw.dig(*keys.map(&:to_s))
    end

    # Count of data points
    # @return [Integer] number of data points
    def count
      data.size
    end

    # First data point
    # @return [Hash, nil] first data point or nil if empty
    def first
      data.first
    end

    # Last data point
    # @return [Hash, nil] last data point or nil if empty
    def last
      data.last
    end

    # Extract numeric values for a column
    # @param column [String] the column name
    # @return [Array<Float>] array of numeric values
    def values_for(column)
      data.select { |row| row.is_a?(Hash) }.map { |row| row[column]&.to_f }.compact
    end

    # Minimum value for a column
    # @param column [String] the column name
    # @return [Float, nil] minimum value or nil if no data
    def min(column)
      values_for(column).min
    end

    # Maximum value for a column
    # @param column [String] the column name
    # @return [Float, nil] maximum value or nil if no data
    def max(column)
      values_for(column).max
    end

    # Sum of values for a column
    # @param column [String] the column name
    # @return [Float] sum of values
    def sum(column)
      values_for(column).sum
    end

    # Average value for a column
    # @param column [String] the column name
    # @return [Float] average value or 0 if no data
    def average(column)
      vals = values_for(column)
      return 0.0 if vals.empty?

      vals.sum / vals.size.to_f
    end

    alias mean average

    # Date range covered by the data
    # @return [Array<String>, nil] [start_date, end_date] or nil if no dates
    def date_range
      dates = data.map { |row| row["period"] || row["date"] }.compact
      return nil if dates.empty?

      dates.minmax
    end

    # Number of days in the period
    # @return [Integer] number of days
    def period_days
      range = date_range
      return 0 unless range

      (Date.parse(range[1]) - Date.parse(range[0])).to_i + 1
    rescue Date::Error
      0
    end

    # Check if data is complete for the date range
    # @return [Boolean] true if all expected days are present
    def complete?
      expected_days = period_days
      return true if expected_days.zero?

      count >= expected_days
    end

    # Find missing dates in the range
    # @return [Array<Date>] array of missing dates
    def missing_dates
      return [] unless date_range

      start_date = Date.parse(date_range[0])
      end_date = Date.parse(date_range[1])
      actual_dates = data.select { |row| row.is_a?(Hash) }.map { |row| Date.parse(row["period"] || row["date"]) }

      (start_date..end_date).reject { |date| actual_dates.include?(date) }
    rescue Date::Error
      []
    end

    # Calculate change metrics for a column
    # @param column [String] the column name (default: "value")
    # @return [Hash, nil] hash with :absolute, :percentage, :first_value, :last_value
    def change(column = "value")
      vals = values_for(column)
      return nil if vals.size < 2

      first_val = vals.first
      last_val = vals.last

      {
        absolute: last_val - first_val,
        percentage: ((last_val - first_val) / first_val * 100).round(4),
        first_value: first_val,
        last_value: last_val
      }
    end

    # Calculate daily changes for a column
    # @param column [String] the column name (default: "value")
    # @return [Array<Hash>] array of change hashes with :absolute and :percentage
    def daily_changes(column = "value")
      vals = values_for(column)
      return [] if vals.size < 2

      vals.each_cons(2).map do |prev, curr|
        {
          absolute: curr - prev,
          percentage: prev.zero? ? 0.0 : ((curr - prev) / prev * 100).round(4)
        }
      end
    end

    # Calculate volatility (standard deviation of daily percentage changes)
    # @param column [String] the column name (default: "value")
    # @return [Float] volatility as standard deviation
    def volatility(column = "value")
      changes = daily_changes(column).map { |c| c[:percentage] }
      return 0.0 if changes.empty?

      mean = changes.sum / changes.size.to_f
      variance = changes.sum { |x| (x - mean)**2 } / changes.size.to_f
      Math.sqrt(variance).round(4)
    end

    # Determine trend direction
    # @param column [String] the column name (default: "value")
    # @return [Symbol] :up, :down, or :flat
    def trend(column = "value")
      change_data = change(column)
      return :flat unless change_data

      pct = change_data[:percentage]

      if pct > 1
        :up
      elsif pct < -1
        :down
      else
        :flat
      end
    end

    # Export data to CSV
    # @param filename [String, nil] optional filename to save CSV
    # @return [String] CSV string or filename if saved
    def to_csv(filename = nil)
      csv_data = CSV.generate do |csv|
        csv << extract_headers
        extract_rows.each { |row| csv << row }
      end

      if filename
        File.write(filename, csv_data)
        filename
      else
        csv_data
      end
    end

    private

    # Extract data array from API response
    # @param response [Hash, Array, Object] raw API response
    # @return [Array<Hash>] extracted data array
    def extract_data(response)
      # Handle array responses (e.g., financial holidays)
      return response if response.is_a?(Array)

      # Handle non-hash/non-array responses
      return [] unless response.is_a?(Hash)

      # Handle standard BOT API format with result.data
      # Only dig if result exists and is a Hash
      result_data = response["result"]
      return [] unless result_data.is_a?(Hash)

      result_data["data"] || []
    end

    # Extract CSV headers from data
    # @return [Array<String>] array of header names
    def extract_headers
      return [] if data.empty?

      first_row = data.first
      case first_row
      when Hash
        first_row.keys
      when Array
        (1..first_row.size).map { |i| "column_#{i}" }
      else
        ["value"]
      end
    end

    # Extract CSV rows from data
    # @return [Array<Array>] array of row arrays
    def extract_rows
      data.map do |row|
        case row
        when Hash
          row.values
        when Array
          row
        else
          [row]
        end
      end
    end
  end
end
