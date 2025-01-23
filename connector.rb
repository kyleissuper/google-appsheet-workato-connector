# frozen_string_literal: true

{
  title: 'Google AppSheet',

  connection: {
    fields: [
      {
        name: 'application_access_key',
        label: 'Application Access Key',
        control_type: 'password',
        optional: false
      },
      {
        name: 'app_id',
        label: 'App ID',
        optional: false
      },
      {
        name: 'region',
        label: 'Region',
        control_type: 'subdomain',
        url: '.appsheet.com',
        hint: 'www or eu',
        optional: false
      },
      {
        name: 'test_table',
        label: 'Test Table',
        hint: 'Please enter a valid table name so the connector' \
        ' can verify connectivity. The table must exist. For' \
        ' continuity, choose the table that is most likely' \
        ' to not change in name.',
        optional: false
      }
    ],

    authorization: {
      type: 'basic_auth',

      apply: lambda do |connection|
        headers('ApplicationAccessKey': connection['application_access_key'])
      end
    },

    base_uri: lambda do |connection|
      "https://#{connection['region']}.appsheet.com/api/v2/apps/#{connection['app_id']}/"
    end
  },

  test: lambda do |connection|
    # This will return an empty row due to the selector, but it's a valid response
    post("tables/#{connection['test_table']}/Action")
      .payload(Action: 'Find', Properties: { Selector: 'TOP(X, 1)' })
  end,

  triggers: {
    updated_row: {
      title: 'New/updated row',
      config_fields: [
        {
          name: 'table_name',
          optional: false
        }
      ],
      poll: lambda do |_connection, input, _closure, _eis, _eos|
        {
          events: post("tables/#{input['table_name']}/Action")
            .payload(Action: 'Find', Rows: [])
        }
      end,
      dedup: lambda do |record|
        record.except('_RowNumber').to_json
      end,
      output_fields: lambda do |_object_definitions, _connection, config_fields|
        post("tables/#{config_fields['table_name']}/Action")
          .payload(Action: 'Find', Rows: [])
          .first
          .keys
          .map do |key|
            { name: key }
          end
      end,
      sample_output: lambda do |_connection, input|
        post("tables/#{input['table_name']}/Action")
          .payload(Action: 'Find', Rows: [])
          .first
      end
    }
  }
}
