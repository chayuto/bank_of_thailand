# frozen_string_literal: true

RSpec.describe BankOfThailand do
  it "has a version number" do
    expect(BankOfThailand::VERSION).not_to be_nil
  end

  it "has the correct version" do
    expect(BankOfThailand::VERSION).to eq("0.1.0")
  end
end
