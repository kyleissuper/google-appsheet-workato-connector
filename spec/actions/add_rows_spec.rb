# frozen_string_literal: true

RSpec.describe 'actions/add_rows', :vcr do
  let(:connector) { Workato::Connector::Sdk::Connector.from_file('connector.rb', settings) }
  let(:settings) { Workato::Connector::Sdk::Settings.from_default_file }
  let(:config_fields) { JSON.parse(File.read('fixtures/triggers/updated_row_input.json')) }
  let(:action) { connector.actions.add_rows }

  describe 'input_fields' do
    subject(:input_fields) { action.input_fields(settings, config_fields) }

    it 'has input_fields' do
      expect(input_fields[0]['name']).to eq('Rows')
      expect(input_fields[0]['properties'][0]['name']).to eq('_RowNumber')
    end
  end

  describe 'execute' do
    let(:test_key) { action.input_fields(settings, config_fields)[0]['properties'][2]['name'] }

    it 'adds a row' do
      output = action.execute(
        settings,
        config_fields.clone.merge(
          {
            'Rows' => [
              { test_key => 'test' }
            ]
          }
        )
      )
      expect(output['Rows']).to be_a(Array)
      expect(output['Rows'].length).to be == 1
    end

    it 'adds multiple rows' do
      output = action.execute(
        settings,
        config_fields.clone.merge(
          {
            'Rows' => [
              { test_key => 'test' },
              { test_key => 'test2' }
            ]
          }
        )
      )
      expect(output['Rows']).to be_a(Array)
      expect(output['Rows'].length).to be == 2
    end
  end

  describe 'output_fields' do
    subject(:output_fields) { action.output_fields(settings, config_fields) }

    it 'has valid output_fields' do
      expect(output_fields[0]['name']).to eq('Rows')
      expect(output_fields[0]['properties'][0]['name']).to eq('_RowNumber')
      expect(output_fields[0]['properties'][1]['name']).to be_a(String)
    end
  end
end
