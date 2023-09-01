#!/bin/bash
#
# entry point
#

stop1 () {
  printf "\rFinishing container.."
  exit 0
}

## Configuration ##
trap stop1 SIGINT
trap stop1 SIGTERM

# checking if log exist
if [ -d "/var/log/otelcollector-log.json" ]; then
    rm /var/log/otelcollector-log.json &
fi

# checking if logrotate config exists
if [ -d "/var/log/otelcollector-log.json" ]; then

cat << 'EOF' > /etc/logrotate.d/otelcollector
/var/log/otelcollector-log.json {
    daily
    missingok
    rotate 2
    compress
}
EOF

fi

# eternal loop
while true
do
  # pid file dont exist
  if [ ! -f "/var/run/collector.pid"  ]; then
    # running cron
    crond &
    # running healthcheck
    ./healthcheck &
    # write pid on file
    echo $! > /var/run/collector.pid
    sleep 3
  else
    PID=$(cat /var/run/collector.pid)
    if [ ! -d "/proc/$PID" ]; then
       # if proccess is not running, stop container
       echo "$PID is not running"
       rm /var/run/collector.pid
       exit 1
    fi
    sleep 5
  fi
done
