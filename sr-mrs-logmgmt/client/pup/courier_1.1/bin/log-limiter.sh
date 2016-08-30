#!/bin/sh

## log limiter for WAS SystemOut.log
## creation: srzkig 30.04.2015

## Init
UNAMECMD=/bin/uname
OSTYP=$($UNAMECMD)
if [ "$OSTYP" == "Linux" ]
then
  WHOAMICMD=/usr/bin/whoami
  FINDCMD=/usr/bin/find
fi
LU=$($WHOAMICMD)
. .$LU.profile

## Defintions
SUSPENDLOG="StashPolice.log"

SUSPENDMESSAGE=" 15MinPenalty Collection of SystemOut.log suspended for next interval due to \
too high volume (>5MB/m). Review your log configuration or contact your \
system administrator, if your logfile is permanently excluded from collection."

INCLUSIONMESSAGE=" WhiteCard Collection of SystemOut.log included in central log collection. \
Logs can be browsed in http://hotsaw.swissre.com"

CONFPATH="/etc/log-courier/conf.d"
updatecount=0

## get active server list        
cd $USER_INSTALL_ROOT/logs

LOGFILELIST=`find . -name "SystemOut.log" -printf "%P\n"`

for LOGFILE in $LOGFILELIST
do
  APPSERVER=$(dirname $LOGFILE)
  cd $USER_INSTALL_ROOT/logs/$APPSERVER
  
  if [ `$FINDCMD . -name 'SystemOut_[0-9]*.log' -mtime -0.00625 -print | wc -w` -gt 1 ]
  then
    /bin/rm -f $CONFPATH/wassys-ml-ls_$APPSERVER.conf
    updatecount=`expr $updatecount + 1`
    ##print suspension with timestamp + message to log
    echo "[`date '+%m/%d/%y %H:%M:%S:999 %Z'`] $SUSPENDMESSAGE" >> $SUSPENDLOG
  
  elif [ ! -f $CONFPATH/wassys-ml-ls_$APPSERVER.conf ]
  then
	
  echo "[ {
    \"paths\": [ \"/opt/was/*/AppServer/profiles/*/logs/$APPSERVER/SystemOut.log\" ], 
    \"fields\": { \"type\": \"wassys\" },
    \"dead time\": \"10m\",
    \"codec\": {
      \"name\": \"multiline\",
      \"pattern\": \"^[[0-9]+/[0-9]+/[0-9]+\",
      \"negate\": true,
      \"what\": \"next\"
    }
} ]" > $CONFPATH/wassys-ml-ls_$APPSERVER.conf
  updatecount=`expr $updatecount + 1`  
  ##print inclusion with timestamp + message to log
  echo "[`date '+%m/%d/%y %H:%M:%S:999 %Z'`] $INCLUSIONMESSAGE" >> $SUSPENDLOG

  fi 

done

exit $updatecount
