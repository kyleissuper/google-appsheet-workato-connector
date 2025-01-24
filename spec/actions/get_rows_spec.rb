# frozen_string_literal: true

RSpec.describe 'actions/get_rows', :vcr do
  let(:connector) { Workato::Connector::Sdk::Connector.from_file('connector.rb', settings) }
  let(:settings) { Workato::Connector::Sdk::Settings.from_default_file }
  let(:config_fields) { JSON.parse(File.read('fixtures/triggers/updated_row_input.json')) }
  let(:input) { config_fields }
  let(:action) { connector.actions.get_rows }

  describe 'input_fields' do
    subject(:input_fields) { action.input_fields(settings, config_fields) }

    it 'has input_fields' do
      expect(input_fields[0]['name']).to eq('_RowNumber')
    end
  end

  describe 'execute' do
    it 'gets rows without filters' do
      output = action.execute(settings, input)
      expect(output['Rows']).to be_a(Array)
      expect(output['Rows'].first).to be_a(Hash)
      expect(output['Rows'].first.keys).to include('_RowNumber')
    end

    it 'gets rows with one filter' do
      output = action.execute(settings, input.merge('_RowNumber' => 1))
      expect(output['Rows']).to be_a(Array)
      expect(output['Rows'].first).to be_a(Hash)
      expect(output['Rows'].first.keys).to include('_RowNumber')
    end

    it 'gets rows with multiple filters' do
      input_local = input.clone
      example_row = action.execute(settings, input).fetch('Rows').first
      example_row.keys.each_with_index do |key, index|
        if index in [2, 3, 4]
          input_local[key] = example_row[key]
        end
      end
      output = action.execute(
        settings,
        input_local
      )
      expect(output['Rows']).to be_a(Array)
      expect(output['Rows'].length).to be > 0
    end
  end

  describe 'output_fields' do
    subject(:output_fields) { action.output_fields(settings, config_fields) }

    it 'has valid output_fields' do
      expect(output_fields[0]['properties']).to be_a(Array)
      expect(output_fields[0]['properties'].first).to be_a(Hash)
    end
  end
end
