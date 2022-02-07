# Home Assistant Add-on: InfluxDB v2

A scalable datastore for metrics, events, and real-time analytics.

The [official InfluxDB add-on](https://github.com/hassio-addons/addon-influxdb) uses
an older version of InfluxDB. I wanted to use the 2.x version so I created this
addo-on.

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```yaml
log_level: info
certfile: fullchain.pem
keyfile: privkey.pem
envvars:
  - name: INFLUXD_FLUX_LOG_ENABLED
    value: "true"
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `log_level`

The `log_level` option controls the level of log output by the addon and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `warning`: Exceptional occurrences that are not errors.
- `error`: Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

### Option: `certfile`

The certificate file to use for SSL.

**Note**: _The file MUST be stored in `/ssl/`, which is the default_

### Option: `keyfile`

The private key file to use for SSL.

**Note**: _The file MUST be stored in `/ssl/`, which is the default_

### Option: `envvars`

This allows the setting of Environment Variables to control InfluxDB
configuration as documented at:

<https://docs.influxdata.com/influxdb/v2.1/reference/config-options/>

**Note**: _Changing these options can possibly cause issues with you instance.
USE AT YOUR OWN RISK!_

These are case sensitive.

#### Sub-option: `name`

The name of the environment variable to set which must start with `INFLUXD_`

#### Sub-option: `value`

The value of the environment variable to set, set the Influx documentation for
full details. Values should always be entered as a string (even true/false values).

## Integrating into Home Assistant

The `influxdb` integration of Home Assistant makes it possible to transfer all
state changes to an InfluxDB database.

You need to do the following steps in order to get this working:

- Click on "OPEN WEB UI" to open the admin web-interface provided by this add-on.
- On the left menu click on the "InfluxDB Admin".
- Create a database for storing Home Assistant's data in, e.g., `homeassistant`.
- Go to the users tab and create a user for Home Assistant,
  e.g., `homeassistant`.
- Add "ALL" to "Permissions" of the created user, to allow writing to your
  database.

Now we've got this in place, add the following snippet to your Home Assistant
`configuration.yaml` file.

```jaml
influxdb:
  api_version: 2
  ssl: true
  host: localhost
  port: 8086
  token: GENERATED_AUTH_TOKEN
  organization: RANDOM_16_DIGIT_HEX_ID
  bucket: BUCKET_NAME
  tags:
    source: HA
  tags_attributes:
    - friendly_name
  default_measurement: units
  exclude:
    entities:
      - zone.home
    domains:
      - persistent_notification
      - person
  include:
    domains:
      - sensor
      - binary_sensor
      - sun
    entities:
      - weather.home
```

Restart Home Assistant.

You should now see the data flowing into InfluxDB by visiting the web-interface
and using the Data Explorer.

Full details of the Home Assistant integration can be found here:

<https://www.home-assistant.io/integrations/influxdb/>

