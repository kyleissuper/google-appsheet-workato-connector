# frozen_string_literal: true

RSpec.describe 'triggers/updated_row', :vcr do
  subject(:output) { connector.triggers.updated_row(input) }

  let(:connector) { Workato::Connector::Sdk::Connector.from_file('connector.rb', settings) }
  let(:settings) { Workato::Connector::Sdk::Settings.from_default_file }
  let(:config_fields) { JSON.parse(File.read('fixtures/triggers/updated_row_input.json')) }
  let(:input) { config_fields }
  let(:trigger) { connector.triggers.updated_row }

  describe 'poll' do
    subject(:output) { trigger.poll(settings, config_fields, input) }

    it 'cannot poll more' do
      expect(output[:can_poll_more]).to eq(false)
    end

    it 'has events' do
      expect(output[:events]).to be_a(Array)
      expect(output[:events].first).to be_a(Hash)
    end

    it 'has next_poll with same config_fields' do
      expect(output[:next_poll]).to eq(config_fields)
    end
  end

  describe 'dedup' do
    let(:record) { { '_RowNumber' => 1, 'Test' => 'Test' } }
    subject(:output) { trigger.dedup(record) }

    it 'removes _RowNumber' do
      expect(output).to eq({ 'Test' => 'Test' }.to_json)
    end
  end

  describe 'sample_output' do
    subject(:sample_output) { trigger.sample_output(settings, input) }

    it 'has row number' do
      expect(sample_output['_RowNumber']).to be_a(String)
    end

    it 'has other columns' do
      expect(sample_output.keys.size).to be > 1
    end
  end

  describe 'input_fields' do
    subject(:input_fields) { trigger.input_fields(settings, config_fields) }

    it 'has no input_fields' do
      expect(input_fields).to eq([])
    end
  end

  describe 'output_fields' do
    subject(:output_fields) { trigger.output_fields(settings, config_fields) }

    it 'has valid output_fields' do
      expect(output_fields).to be_a(Array)
      expect(output_fields.first).to be_a(Hash)
    end
  end
end
