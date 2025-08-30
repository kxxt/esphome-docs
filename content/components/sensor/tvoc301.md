---
description: "Instructions for setting up TVOC-301 sensors"
title: "TVOC-301 Sensor"
params:
  seo:
    description: Instructions for setting up TVOC-301 sensors
    image: tvoc301.png
---

The `tvoc301` sensor platform allows you to use TVOC-301 sensors to measure
volatile organics, effective CO₂ and formaldehyde concentration in ESPHome.

{{< img src="tvoc301.png" alt="Image" caption="TVOC-301 Sensor" width="50.0%" class="align-center" >}}

As the communication with the TVOC-301 is done using UART, you need to have an [UART bus](#uart) in your configuration with the `rx_pin` connected to the TX pin of the TVOC-301.
The baud rate needs to be set to 9600.

```yaml
# Example configuration entry
uart:
  rx_pin: D2
  baud_rate: 9600

sensor:
  - platform: tvoc-301
    tvoc:
      name: TVOC
    eco2:
      name: eCO₂
    formaldehyde:
      name: Formaldehyde
```

## Configuration variables

- **tvoc** (*Optional*): TVOC sensor with unit in µg per cubic meter.
  All options from [Sensor](#config-sensor).

- **eco2** (*Optional*): eCO₂ sensor with unit in ppm.
  All options from [Sensor](#config-sensor).

- **formaldehyde** (*Optional*): Formaldehyde sensor with unit in µg per cubic meter.
  All options from [Sensor](#config-sensor).

- **uart_id** (*Optional*, [ID](#config-id)): Manually specify the ID of the [UART Component](#uart) if you want
  to use multiple UART buses.

- **update_interval** (*Optional*, [Time](#config-time)): The polling interval for this sensor.
  Defaults to 60s.

## See Also

- [Sensor Filters](#sensor-filters)
- {{< apiref "tvoc301/tvoc301.h" "tvoc301/tvoc301.h" >}}
