#!/bin/ash

set -e

# Fix write permissions for mosquitto directories
chown --no-dereference --recursive mosquitto /mosquitto/log
chown --no-dereference --recursive mosquitto /mosquitto/data

mkdir -p /var/run/mosquitto \
  && chown --no-dereference --recursive mosquitto /var/run/mosquitto

# Adjust configuration to support Mosquitto 2.x
if [ $(echo $VERSION | cut -d "." -f1) -gt 1 ]; then
  # Use 'listener' instead of 'port'
  sed -i "s/port 1883/listener 1883/g" /mosquitto/config/mosquitto.conf
fi

if ( [ -z "${MQTT_USER}" ] || [ -z "${MQTT_PASSWORD}" ] ); then
  echo "MQTT_USER or MQTT_PASSWORD not defined"
  exit 1
fi

# create mosquitto passwordfile
touch passwordfile
mosquitto_passwd -b passwordfile $MQTT_USER $MQTT_PASSWORD

exec "$@"
