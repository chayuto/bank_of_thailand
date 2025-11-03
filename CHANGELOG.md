## [Unreleased]

## [0.2.0] - 2025-11-04

### Added
- **Response wrapper class** with comprehensive data analysis utilities
  - Basic statistics: `count`, `first`, `last`, `min`, `max`, `sum`, `average`/`mean`
  - Date range analysis: `date_range`, `period_days`, `complete?`, `missing_dates`
  - Rate change calculations: `change`, `daily_changes`, `volatility`, `trend`
  - CSV export: `to_csv` method for easy data export
  - Backward compatibility: `[]` and `dig` methods for hash-like access
- Enhanced test coverage (117 examples, 100% pass rate)
- Updated README with Response class documentation

### Changed
- All API methods now return `Response` objects instead of raw hashes
- Improved error handling for different response formats (arrays, hashes, edge cases)

## [0.1.0] - 2025-11-03

### Added
- Initial release with 11 API resources
- Exchange rate APIs (weighted-average interbank THB/USD and average exchange rates for 19 currencies)
- Interest rate APIs (deposit rates, loan rates, interbank rates, Thai Baht implied rates)
- Securities & markets APIs (debt securities auction results, swap point onshore)
- Regulatory APIs (BOT license check, financial institutions holidays)
- Search API (series search)
- Comprehensive test coverage (66 examples, 100% pass rate)
- RuboCop configuration for code quality
- YARD documentation support
- Ruby 3.0+ support with CI testing across 3.0, 3.1, 3.2, 3.3
