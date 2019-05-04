#!/bin/bash

# date in format yyyymmdd
THEDATE=`date +"%Y%m%d"`

HOSTNAME=`hostname`
#HOSTNAME=Diesel
HOSTNAME=${HOSTNAME%%.*}
if echo "$HOSTNAME" | grep DanysMacBook > /dev/null 2>&1 ; then
    HOSTNAME="Dany"
fi
NEWNAME="$HOSTNAME$THEDATE"

if ! mount | grep "$HOSTNAME"[0-9][0-9]* > /dev/null 2>&1; then
    if ! `diskutil apfs list | grep "$HOSTNAME"[0-9][0-9]* > /dev/null 2>&1`; then
        echo -e "\n########################################\n####\n#### Target Disk not present. Exiting.\n####"
        exit
    else
        THEDISK=`diskutil apfs list|grep "$HOSTNAME"[0-9][0-9]* |awk '{print $3}'`
        echo -e "\n#### Mounting $THEDISK"
        diskutil apfs unlockVolume $THEDISK
        if ! mount | grep "$HOSTNAME"[0-9][0-9]* > /dev/null 2>&1; then
            echo -e "\n########################################\n####\n#### Failed to unlock/mount $THEDISK. Exiting.\n####"
            exit
        fi
    fi
fi

OLDNAME=`mount | grep "$HOSTNAME"[0-9][0-9]* | awk '{print $3}'`; OLDNAME=`basename $OLDNAME`
#echo "oldname=$OLDNAME"
#echo "newname=$NEWNAME"

if [ "$OLDNAME" == "$NEWNAME" ]; then
    echo -e "\n########################################\n####\n#### $OLDNAME does not need to be renamed.\n####"
    exit
fi

############################################################
# force user to type a random string to avoid
# accidental execution of this script
############################################################
# if tr does not work in the line below, try this:
#  export STUPID_STRING=`cat /dev/urandom|LC_ALL=C tr -dc "a-zA-Z0-9"|fold -w 6|head -n 1`
############################################################
export STUPID_STRING="k4JgHrt"
if [ -e /dev/urandom ];then
  export STUPID_STRING=`cat /dev/urandom|LC_CTYPE=C tr -dc "a-zA-Z0-9"|fold -w 6|head -n 1`
fi
echo -e "\n### type \"${STUPID_STRING}\" to rename $OLDNAME to $NEWNAME\n"
idiot_counter=0
while true; do
  read line
  case $line in
    ${STUPID_STRING}) break;;
    *)
      idiot_counter=$(($(($idiot_counter+1))%2));
      if [[ $idiot_counter == 0 ]];then
        echo -e "###\n### YOU FAIL !\n###\n### exiting..."; exit;
      fi
      echo "### to rename $OLDNAME to $NEWNAME, type \"${STUPID_STRING}\", CTRL-C to abort";
      ;;
  esac
done

diskutil rename $OLDNAME $NEWNAME
