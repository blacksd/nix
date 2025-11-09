{
  config,
  lib,
  pkgs,
  ...
}: {
  # Raspberry Pi 4 Fan Control via PWM
  # Controls the fan speed based on CPU temperature

  # Enable device tree overlay for PWM fan control
  hardware.deviceTree = {
    enable = true;
    overlays = [
      {
        name = "gpio-fan";
        dtsText = ''
          /dts-v1/;
          /plugin/;

          / {
            compatible = "brcm,bcm2711";

            fragment@0 {
              target-path = "/";
              __overlay__ {
                fan: pwm-fan {
                  compatible = "pwm-fan";
                  pwms = <&pwm1 0 40000>;  // 25 kHz PWM
                  cooling-min-state = <0>;
                  cooling-max-state = <3>;
                  #cooling-cells = <2>;
                  cooling-levels = <0 102 170 255>;  // 0%, 40%, 66%, 100%
                };
              };
            };

            fragment@1 {
              target = <&cpu_thermal>;
              __overlay__ {
                trips {
                  cpu_warm: cpu-warm {
                    temperature = <50000>;  // 50°C - fan starts
                    hysteresis = <5000>;
                    type = "active";
                  };
                  cpu_hot: cpu-hot {
                    temperature = <65000>;  // 65°C - fan medium
                    hysteresis = <5000>;
                    type = "active";
                  };
                  cpu_very_hot: cpu-very-hot {
                    temperature = <75000>;  // 75°C - fan full speed
                    hysteresis = <5000>;
                    type = "active";
                  };
                };
                cooling-maps {
                  map0 {
                    trip = <&cpu_warm>;
                    cooling-device = <&fan 1 1>;
                  };
                  map1 {
                    trip = <&cpu_hot>;
                    cooling-device = <&fan 2 2>;
                  };
                  map2 {
                    trip = <&cpu_very_hot>;
                    cooling-device = <&fan 3 3>;
                  };
                };
              };
            };

            fragment@2 {
              target = <&pwm1>;
              __overlay__ {
                status = "okay";
                pinctrl-names = "default";
                pinctrl-0 = <&pwm1_gpio13>;
              };
            };
          };
        '';
      }
    ];
  };

  # Alternative: Simple config.txt approach (if above doesn't work)
  # Uncomment this and comment out the deviceTree section above
  # hardware.raspberry-pi."4".config.txt = ''
  #   # Fan control via GPIO
  #   dtoverlay=gpio-fan,gpiopin=14,temp=55000
  # '';

  # Install monitoring tools
  environment.systemPackages = with pkgs; [
    lm_sensors  # For temperature monitoring
  ];

  # Optional: Create a systemd service for manual fan control
  # This is a fallback if hardware control doesn't work
  systemd.services.fan-control = {
    enable = false;  # Set to true if you want manual control instead
    description = "Simple PWM Fan Control";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = pkgs.writeShellScript "fan-control" ''
        #!/bin/sh
        # Simple fan control script
        # Adjust fan speed based on CPU temperature

        FAN_GPIO=14  # GPIO pin for fan (usually GPIO14 for official case)

        # Enable GPIO
        echo "$FAN_GPIO" > /sys/class/gpio/export || true
        echo "out" > /sys/class/gpio/gpio$FAN_GPIO/direction

        while true; do
          # Get CPU temperature (in millidegrees)
          TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)

          # Convert to degrees
          TEMP_C=$((TEMP / 1000))

          # Control fan based on temperature
          if [ $TEMP_C -lt 50 ]; then
            # Below 50°C - fan off
            echo 0 > /sys/class/gpio/gpio$FAN_GPIO/value
          elif [ $TEMP_C -lt 65 ]; then
            # 50-65°C - fan on low (you'd need PWM for variable speed)
            echo 1 > /sys/class/gpio/gpio$FAN_GPIO/value
          else
            # Above 65°C - fan on full
            echo 1 > /sys/class/gpio/gpio$FAN_GPIO/value
          fi

          sleep 5
        done
      '';
      Restart = "always";
    };
  };
}
