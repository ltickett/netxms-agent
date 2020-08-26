#!/bin/bash

# https://wiki.netxms.org/wiki/Agent_Configuration_File

conf=/data/nxagent.conf
log_file=/data/nxagent.log
MASTERSERVER=${MASTERSERVER:-127.0.0.1}

if [ ! -f "${conf}" ];
then
    echo "Generating NetXMS Agent config file ${conf}"
    cat > ${conf} <<EOL
[Core]
LogFile = ${log_file}
MasterServers = ${MASTERSERVER}
$NXCONFIG
EOL
fi


# Usage: nxagentd [options]
# Where valid options are:
#   -c <file>  : Use configuration file <file> (default {search})
#   -C         : Load configuration file, dump resulting configuration, and exit
#   -d         : Run as daemon/service
#   -D <level> : Set debug level (0..9)
#   -f         : Run in foreground
#   -g <gid>   : Change group ID to <gid> after start
#   -G <name>  : Use alternate global section <name> in configuration file
#   -h         : Display help and exit
#   -K         : Shutdown all connected external sub-agents
#   -M <addr>  : Download config from management server <addr>
#   -p         : Path to pid file (default: /var/run/nxagentd.pid)
#   -P <text>  : Set platform suffix to <text>
#   -r <addr>  : Register agent on management server <addr>
#   -u <uid>   : Chhange user ID to <uid> after start
#   -v         : Display version and exit


ARGS="-f"
[ -n "$REGISTERSERVER" ] && ARGS="$ARGS -r $REGISTERSERVER"
[ -n "$CONFIGSERVER" ] && ARGS="$ARGS -M $CONFIGSERVER"
[ -n "$LOGLEVEL" ] && ARGS="$ARGS -D $LOGLEVEL"
[ -n "$PLATFORMSUFFIX" ] && ARGS="$ARGS -P $PLATFORMSUFFIX"

echo "Starting nxagentd"
exec nxagentd $ARGS -c "${conf}" 
