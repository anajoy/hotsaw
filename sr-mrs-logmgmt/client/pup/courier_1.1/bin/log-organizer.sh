#! /bin/sh

## log organizer for WebSphere Logs
## invoked by log-courier init.d script
## --------------------------
## 1. invokes log-limiter.sh to limit log collection to <2 rotations/9 min. 
## 2. invokes dailiy-skulker.sh (compress rotated logs, rotates native_stderr.log, etc.)   
##    (not implented yet)
## 3. invokes weekly-skulker.sh (cleanup filesystem from dumps, etc.)
##    (not implented yet)
## --------------------------
## creation: srzkig 30.04.2015
## --------------------------

COURIER_LOG="/etc/log-courier"
COURIER_BIN="$COURIER_LOG/bin"
LIMITER="log-limiter.sh"
WAS_HOME="$(dirname /opt/was/[edtp][a-z0-9]/home/.was[edtp][a-z0-9].profile)"
WAS_USER="$(basename /opt/was/[edtp][a-z0-9]/home/.was[edtp][a-z0-9].profile | awk '{ print substr($1,2,5) }')"
WAS_GROUP="deploy"     
## Orgainzer.log is written by default to /var/lib/log-courier
ORGANIZER_LOG="/var/log/log-courier/Organizer.log"

trap processUserSig SIGUSR1                                         
processUserSig() {                 
	echo "[`date '+%m/%d/%y %H:%M:%S:999 %Z'`] INFO Start running log-organizer and housekeeping tasks" >> $ORGANIZER_LOG 
}                                                                    

while true; do

  ### limits log collection by running log-limiter.sh
                 
  ## invoke script with local was user
  chroot --userspec $WAS_USER:$WAS_GROUP / sh -c "
    cd $WAS_HOME
    $COURIER_BIN/$LIMITER
  "
  updatecount=$?
   
  if [ $updatecount -gt 0 -a $updatecount -le 125 ]
  then      
    echo "[`date '+%m/%d/%y %H:%M:%S:999 %Z'`] INFO $updatecount log-courier config update(s) occurred." >> $ORGANIZER_LOG	
    /etc/init.d/log-courier reload  
  elif [ $updatecount -eq 0 ]                
  then
    echo "[`date '+%m/%d/%y %H:%M:%S:999 %Z'`] INFO log-courier config is fine." >> $ORGANIZER_LOG
  else              
    echo "[`date '+%m/%d/%y %H:%M:%S:999 %Z'`] WARN return code $updatecount is too high. Check permissions to run chroot command." >> $ORGANIZER_LOG
  fi                                                                
  ## recheck every 15 min.
  sleep 900

  ### check for time window daily 03:00-03:15 and run daily-skulker.sh if true

  ### check for time window weekly Su 03:15-03:30 and run weekly-skulker.sh if true


done
