#!/bin/bash
source export.sh
/opt/trc/bin/trc eval "TRC.Release.migrate()"
/opt/trc/bin/trc start
