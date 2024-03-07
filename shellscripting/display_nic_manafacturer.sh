#!/bin/bash
# OUI Look file added with ieee-data/hwdata package
id_like=$(awk -F= '/^ID_LIKE/{print $2}' /etc/os-release)
if [ "$id_like" == "debian" ]; then
  FILE=/usr/share/ieee-data/oui.txt
else
  FILE=/usr/share/hwdata/oui.txt
fi

# Check file is there
if [ ! -f $FILE ]; then
  echo "$FILE not found, install ieee-data for Debian or hwdata for RHEL"
  exit 1
fi

# Display Nic data
# Replace : with - to match format of lookup file
ip link show | awk '/ether/{gsub(":","-");print $2}'| while read -r MAC ;
do
  OUI_ADDR=$(echo $MAC | cut -d '-' -f 1,2,3 | tr '[:lower:]' '[:upper:]')
  ENTRY=$(grep -m 1 -i "$OUI_ADDR" $FILE)
  if [ -n "$ENTRY" ]; then
    #   we want to print just the manufacturer which the 3rd field onwards
    #   so we clear the first and second field and make sure we delete leading spaces
    #   before printing complete line
    echo $ENTRY | awk '{$1=""; $2=""; gsub("^  ", ""); print $0}'
  else
    echo "$MAC not found in $FILE"
  fi
done
