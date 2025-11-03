# frozen_string_literal: true

require_relative "lib/bank_of_thailand/version"

Gem::Specification.new do |spec|
  spec.name = "bank_of_thailand"
  spec.version = BankOfThailand::VERSION
  spec.authors = ["Chayut Orapinpatipat"]
  spec.email = ["chayut_o@hotmail.com"]

  spec.summary = "Ruby wrapper for the Bank of Thailand (BOT) API"
  spec.description = "A comprehensive Ruby gem for accessing Bank of Thailand's public data services including exchange rates, interest rates, debt securities, and economic statistics."
  spec.homepage = "https://github.com/chayuto/bank_of_thailand"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/chayuto/bank_of_thailand"
  spec.metadata["changelog_uri"] = "https://github.com/chayuto/bank_of_thailand/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://rubydoc.info/gems/bank_of_thailand"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "faraday", "~> 2.7"
  spec.add_dependency "faraday-retry", "~> 2.0"

  # Development dependencies
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rubocop", "~> 1.50"
  spec.add_development_dependency "rubocop-rake", "~> 0.6"
  spec.add_development_dependency "rubocop-rspec", "~> 2.20"
  spec.add_development_dependency "webmock", "~> 3.18"
  spec.add_development_dependency "yard", "~> 0.9"
end
