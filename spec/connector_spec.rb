# frozen_string_literal: true

RSpec.describe 'connector', :vcr do
  let(:connector) { Workato::Connector::Sdk::Connector.from_file('connector.rb', settings) }
  let(:settings) { Workato::Connector::Sdk::Settings.from_default_file }

  it { expect(connector).to be_present }

  describe 'test' do
    subject(:output) { connector.test(settings) }
    it { expect(output).to eq([]) }
  end
end
