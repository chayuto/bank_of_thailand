# Bank of Thailand API Wrapper

A Ruby gem for accessing the Bank of Thailand's public API services. This gem provides a clean, object-oriented interface to interact with BOT's official API catalog.

[![Ruby](https://img.shields.io/badge/ruby-%3E%3D%203.0.0-ruby.svg)](https://www.ruby-lang.org/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE.txt)

## Features

- **Token-based Authentication** - Secure API access using BOT's authorization system
- **11 API Resources** - Complete coverage of all documented BOT API products
- **Smart Response Objects** - Built-in statistics, CSV export, and data analysis
- **Type Safety** - Comprehensive error handling with custom exception classes
- **Flexible Configuration** - Global or instance-level configuration options
- **Full Test Coverage** - 117 examples with 100% pass rate
- **YARD Documentation** - Complete API documentation for all endpoints

## Installation

Add this line to your application's Gemfile:

```ruby
gem "bank_of_thailand"
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install bank_of_thailand
```

## Prerequisites

Before using this gem, you need to obtain an API token from the Bank of Thailand API Portal:

1. **Create an Account** at [https://portal.api.bot.or.th](https://portal.api.bot.or.th)
2. **Create an Application** in your profile (Profile → My apps)
3. **Subscribe to API Products** from the Catalogues menu
4. **Select a Plan** and add to cart
5. **Activate Subscription** by selecting your application
6. **Retrieve Your Token** from Profile → My apps → Select your app → Copy token

Note: A token can only access APIs from subscribed products. Make sure to subscribe to the products you need.

## Configuration

### Global Configuration

Configure the gem globally for use throughout your application:

```ruby
require "bank_of_thailand"

BankOfThailand.configure do |config|
  config.api_token = ENV["BOT_API_TOKEN"]  # Required
  config.timeout = 30                       # Optional, default: 30 seconds
  config.max_retries = 3                    # Optional, default: 3
end

# Create a client using global configuration
client = BankOfThailand::Client.new
```

### Instance Configuration

Configure individual client instances:

```ruby
client = BankOfThailand::Client.new do |config|
  config.api_token = "your_token_here"
  config.timeout = 60
end
```

**Available Options:** `api_token` (required), `base_url`, `timeout`, `max_retries`, `logger`

## Usage

### Available API Resources

The gem provides access to 11 BOT API resources:

```ruby
client = BankOfThailand::Client.new

# Exchange Rates
client.exchange_rate          # Weighted-average Interbank Exchange Rate (THB/USD)
client.average_exchange_rate  # Average Exchange Rate (THB/Foreign Currencies)

# Interest Rates
client.deposit_rate           # Deposit Interest Rates
client.loan_rate              # Loan Interest Rates
client.interbank_rate         # Interbank Transaction Rates
client.implied_rate           # Thai Baht Implied Interest Rates

# Securities & Markets
client.debt_securities        # Debt Securities Auction Results
client.swap_point             # Swap Point Onshore

# Regulatory & Reference
client.license_check          # BOT License Check
client.financial_holidays     # Financial Institutions' Holidays
client.search_series          # Search Stat APIs
```

### Working with Responses

All API calls return a `Response` object with built-in data analysis features:

```ruby
rates = client.exchange_rate.daily(
  start_period: "2025-01-01",
  end_period: "2025-01-31"
)

# Access data
rates.data                     # Array of data points
rates.count                    # Number of records
rates.first                    # First record
rates.last                     # Last record

# Quick statistics
rates.average("value")         # Average rate
rates.min("value")             # Minimum rate
rates.max("value")             # Maximum rate

# Analyze changes
rates.change("value")          # Overall change with percentage
rates.volatility("value")      # Daily volatility
rates.trend("value")           # :up, :down, or :flat

# Export to CSV
rates.to_csv("rates.csv")      # Save to file
csv_string = rates.to_csv      # Get CSV string

# Check completeness
rates.date_range               # ["2025-01-01", "2025-01-31"]
rates.complete?                # All dates present?
rates.missing_dates            # Array of missing dates
```

### Exchange Rates

#### Weighted-average Interbank Exchange Rate (THB/USD)

```ruby
# Daily rates
daily_rates = client.exchange_rate.daily(
  start_period: "2025-01-01",
  end_period: "2025-01-31"
)

# Monthly, quarterly, and annual rates also available
monthly = client.exchange_rate.monthly(start_period: "2025-01", end_period: "2025-03")
quarterly = client.exchange_rate.quarterly(start_period: "2025-Q1", end_period: "2025-Q2")
annual = client.exchange_rate.annual(start_period: "2020", end_period: "2024")
```

#### Average Exchange Rate (Multiple Currencies)

```ruby
# Daily average rates with optional currency filter
rates = client.average_exchange_rate.daily(
  start_period: "2025-01-01",
  end_period: "2025-01-31",
  currency: "USD"  # Optional: filter by currency
)

# Also supports monthly, quarterly, and annual
```

### Interest Rates

```ruby
# Deposit rates
deposit = client.deposit_rate.rates(
  start_period: "2025-01-01",
  end_period: "2025-01-31"
)
deposit_avg = client.deposit_rate.average_rates(start_period: "2025-01-01", end_period: "2025-01-31")

# Loan rates
loan = client.loan_rate.rates(start_period: "2025-01-01", end_period: "2025-01-31")
loan_avg = client.loan_rate.average_rates(start_period: "2025-01-01", end_period: "2025-01-31")

# Interbank rates (with optional term_type filter)
interbank = client.interbank_rate.rates(
  start_period: "2025-01-01",
  end_period: "2025-01-31",
  term_type: "O/N"  # Optional
)

# Implied rates (with optional rate_type filter)
implied = client.implied_rate.rates(
  start_period: "2025-01-01",
  end_period: "2025-01-31",
  rate_type: "ONSHORE : T/N"  # Optional
)
```

### Securities & Markets

```ruby
# Debt securities auction results
results = client.debt_securities.auction_results(
  start_period: "2025-01-01",
  end_period: "2025-01-31"
)

# Swap point onshore (with optional term_type filter)
swap = client.swap_point.rates(
  start_period: "2025-01-01",
  end_period: "2025-01-31",
  term_type: "1 Month"  # Optional
)
```

### Regulatory & Reference Data

```ruby
# Search for authorized entities
results = client.license_check.search_authorized(
  keyword: "finance",
  page: 1,      # Optional
  limit: 10     # Optional
)

# Get license details
license = client.license_check.license(auth_id: "12345", doc_id: "DOC-001")

# Get entity details
entity = client.license_check.authorized_detail(id: 12345)

# Financial holidays
holidays = client.financial_holidays.list(year: "2025")

# Search series
series = client.search_series.search(keyword: "government debt")
```

## Error Handling

The gem provides specific exception classes for different error scenarios:

```ruby
begin
  rates = client.exchange_rate.daily(start_period: "2025-01-01", end_period: "2025-01-31")
rescue BankOfThailand::AuthenticationError
  puts "Invalid API token"
rescue BankOfThailand::RateLimitError => e
  sleep e.retry_after
  retry
rescue BankOfThailand::RequestError => e
  puts "Request failed: #{e.message}"
end
```

**Exception Types:** `ConfigurationError`, `AuthenticationError`, `NotFoundError`, `RateLimitError`, `ServerError`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Run `rake spec` to execute tests. Use `bin/console` for an interactive prompt.

```bash
# Run tests
bundle exec rspec

# Run linter
bundle exec rubocop

# Generate documentation
bundle exec yard doc
```

## API Documentation

For detailed information about the Bank of Thailand APIs:

- **API Portal**: [https://portal.api.bot.or.th](https://portal.api.bot.or.th)
- **Production Gateway**: [https://gateway.api.bot.or.th](https://gateway.api.bot.or.th)
- **Official BOT Website**: [https://www.bot.or.th](https://www.bot.or.th)

## Contributing

Bug reports and pull requests are welcome at [github.com/chayuto/bank_of_thailand](https://github.com/chayuto/bank_of_thailand).

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a Pull Request

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and release notes.

