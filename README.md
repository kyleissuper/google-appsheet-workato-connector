# Google AppSheet Connector for Workato

Environment variables required:
* API_TOKEN (from Workato, see [docs](https://docs.workato.com/developing-connectors/sdk/cli/guides/getting-started.html#step-4-push-to-your-workato-workspace))
* VCR_RECORD_MODE (recommended value: new_episodes)
* EDITOR (e.g. vim, nano, notepad)

To add credentials for testing:
1. `workato edit settings.yaml.enc`
2. Add as yaml, for example:
```yaml
application_access_key: V2-YOUR-APPLICATION-ACCESS-KEY
app_id: YOUR-APP-ID
region: www
test_table: YOUR-TEST-TABLE
```
3. Workato will save this with an encryption key at `master.key`

To set up AppSheet for specs: have one table with at least 3 columns, all simple types

To run specs: `bundle exec rspec spec/`

To run a specific component manually: `workato exec [params]`, see [docs](https://docs.workato.com/developing-connectors/sdk/cli/reference/cli-commands.html#workato-exec)

To push to Workato: `workato push --api-token $API_TOKEN`
