#!/bin/bash

## Proof of concept, how to backup a single Patch and the whole bank from a ZFXB3
## and convert it to several formats simultaneously.
## It reads the name of the patch and set it as filename.
## It creates a (amidi) SysEx file, and a human readable plain text file.
## Not ready yet.
## e.g.
## ./zfxbackup.sh -s /save/to/path/



# Parse arguments
usage() {
    echo "Usage: $0 [-h] [-v] [-s /patch/to/directory]"

    echo "  -h  Help. Display this message and quit."
    echo "  -s  Save bank to directory. e.g. ./zfxbackup.sh -s /home/user/Desktop/ZFXB3_Patches/Bankname"
    echo "  -t  *Not implemented yet* Transmit bank back to device."
    echo "  -v  Version. Print version number and quit."
    exit
}

date=$(date)
mod=4F
dirname=""
optspec="hvs:"
while getopts "$optspec" optchar
do
    case "${optchar}" in
        h)
            usage
	    exit 0
            ;;

        s)
            dirname="$OPTARG"
            ;;
        v)
            echo "0.00.002 alpha"
            exit 1
            ;;
    	:) 
            echo "Error: -$OPTARG requires an argument" 
            usage
            exit 1
            ;;
        ?)
            echo "Error: unknown option -$OPTARG" 
            usage
            exit 1
            ;;
        *)
            usage
            ;;
    esac
done


if [ -z "$dirname" ]; then
  echo "Error: you must specify a directory name using -s"
  usage
  exit 1
fi

## Creates a directory, if it not exist.
if [ ! -e "$dirname" ]; then
  mkdir $dirname; 
fi

if [ ! -d "$dirname" ]; then
  echo "Error: the dir_name argument must be a directory"
  exit 1
fi




## Unlock device:
amidi -p hw:2 -S "F0 52 00 $mod 50 F7" -i 0.15

## Store the current bank position before start backup
pos=$(amidi -p hw:2 -S "F0 52 00 $mod 33 F7" -d -t 0.15)
poscut=("${pos:19:27}")


i=$((0x0))

for i in $(seq 0 99); do
  var=$((i ++))
  varh=$(echo 16o${var}p |dc)

  ## Change Patch from A0 to J9:
  amidi -p hw:2 -S "C0 $varh" -i 0.15

  ## Request current patch configuration:
  patchname=$(amidi -p hw:2 -S "F0 52 00 $mod 29 F7" -d -t 0.15)
  #echo "Patch: $patchname"

  ## Cut the answer to position of hex filename:
  namecuth=("${patchname:166:17} ${patchname:187:11}")
  #echo "Cut: $namecut"

  ## Convert hex to string:
#  namecuts=$(echo "$namecuth" | xxd -r -p) 
#  xxd is a part of vim / unnecessary dependency
  namecuts=$(for c in `echo "$namecuth"`; do printf "\x$c"; done;)
#  echo "Hex Cut: $namecuts"

  ## Save Patch to a plain text file:
  echo $date > $dirname/"$namecuts".txt
  echo "Patchname: $namecuts" >> $dirname/"$namecuts".txt
  echo "SysEx Message:" >> $dirname/"$namecuts".txt
  echo $patchname >> $dirname/"$namecuts".txt
  echo "Path: $dirname" >> $dirname/"$namecuts".txt
  echo "Description:" >> $dirname/"$namecuts".txt
  
  ## Save Patch to (amidi) SysEx file:
  amidi -p hw:2 -S "F0 52 00 $mod 29 F7" -r $dirname/"$namecuts".syx -t 0.15

  ## Save Patch to a .b3p file. Need to reverse engineering the message for the complete patch first.
  ## Save complete bank to an own .xml-file-structure:
  ## 

done



## Jump back to last patch used
amidi -p hw:2 -S "$poscut"

sleep 0.15
## Lock device again:
amidi -p hw:2 -S "F0 52 00 $mod 51 F7" -i 0.15 >&2
