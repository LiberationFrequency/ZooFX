#!/bin/bash

## Proof of concept, how to backup a single Patch and the whole bank from a ZFXB3
## and convert it to several formats simultaneously.
## It reads the name of the patch and set it as filename.
## It creates two (amidi) SysEx files, the .b3x is a message of the patch without locator. 
## The .b3y contains a similar representation of the patch with a locator compared to CC. 
## The .b3y-file should be stored in the bank directory, but I don't know the perfect syntax. 
## Additional it creates a human readable plain text file. In total 401 objects in the folder.
## Not ready yet.
## e.g.
## ./zfxbkp.sh -s /save/to/path/

## Known issues
## Two or more patches with the same name will be overwritten. 
## Very slow, but this is not very urgent at the moment.
## It is recommend to backup a fresh booted system,because it reply sometimes
## the full amidi dump cache.  

# Parse arguments
usage() {
    echo "Usage: $0 [-h] [-v] [-s /patch/to/directory]"

    echo "  -h  Help. Display this message and quit."
    echo "  -s  Save bank to directory. e.g. ./zfxbackup.sh -s /home/user/Desktop/ZFXB3_Patches/Bankname"
    echo "  -t  *Not implemented yet* Transmit bank back to device."
    echo "      Temporary transmit it back with 'amidi -p hw:2,0,0 -s filename' manually."
    echo "  -v  Version. Print version number and quit."
    exit
}


dirname=""
bankname=bank
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
            echo "0.00.004 alpha"
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



date=$(date)

## Identify device
id=$(amidi -p hw:2,0,0 -S "F0 7E 00 06 01 F7" -d -t 0.3)

# Manufacturer ID
man=("${id:16:2}")
case "$man" in
        52) mans=Zoom
            ;;
esac

# Model ID
mod=("${id:19:2}")
case "$mod" in
        4F) mods=B3
            ;;
#        59) mods=G3x
#            ;;
#        ??) mods=B2
#            ;;
#        ??) mods=G5
#            ;;

esac

# System version
verh=("${id:31:11}")
# Convert hex2string
vers=$(for c in `echo "$verh"`; do printf "\x$c"; done;)

## Unlock device:
amidi -p hw:2,0,0 -S "F0 $man 00 $mod 50 F7" -i 0.3

## Store the current bank position before start backup
pos=$(amidi -p hw:2,0,0 -S "F0 $man 00 $mod 33 F7" -d -t 0.3)
poscut=("${pos:19:27}")


i=$((0x0))

for i in $(seq 0 99); do
  var=$((i ++))
  varh=$(echo 16o${var}p |dc)

  ## Change Patch from A0 to J9:
  amidi -p hw:2,0,0 -S "C0 $varh" -i 0.3

  ## Request global patch configuration with bank information:
  sysex=$(amidi -p hw:2,0,0 -S "F0 $man 00 $mod 09 00 00 $varh F7" -d -t 0.3)
  echo ""
  echo "Patch: $sysex"

  ## Cut the answer to position of hex filename:
  namecuth=("${sysex:181:17} ${sysex:202:11}")
  echo "Cut: $namecuth"

  ## Convert hex to string:
  namecuts=$(for c in `echo "$namecuth"`; do printf "\x$c"; done;)
  echo "String Cut: $namecuts"

  ## CC extract:
  cccuth=("${sysex:22:2}")


######### not silent #################
  ## Request current patch configuration:
  sysex1=$(amidi -p hw:2,0,0 -S "F0 $man 00 $mod 29 F7" -d -t 0.3)
  ## Cut the answer to position of hex filename:
#  namecuth1=("${sysex:166:17} ${sysex:187:11}")
#######################################




  ## Save Patch to a plain text file:
  echo $date > $dirname/"$namecuts".txt
  echo "Manufacturer: $mans ("ID: $man")" >> $dirname/"$namecuts".txt
  echo "Model: $mods ("ID: $mod")" >> $dirname/"$namecuts".txt
  echo "System Version: $vers" >> $dirname/"$namecuts".txt
  echo "Patchname: $namecuts" >> $dirname/"$namecuts".txt

  echo "i: $i"

  ih=$(echo 16i${var}p |dc)
  echo "ih: $ih"

  bankx=$(($ih+(0xA0)))
  echo "bankx: $bankx"

  banks=$(echo 16o${bankx}p |dc)
  echo "banks: $banks"

  echo "Bank Location: $cccuth (CC) / Bank: $banks (works only up to F9)" >> $dirname/"$namecuts".txt
  echo "SysEx Message with location (78 byte):" >> $dirname/"$namecuts".txt
  echo $sysex >> $dirname/"$namecuts".txt
  echo "SysEX message of current patch without location (68 byte):" >> $dirname/"$namecuts".txt
  echo $sysex1 >> $dirname/"$namecuts".txt
  echo "Path: $dirname" >> $dirname/"$namecuts".txt
  echo "Description:" >> $dirname/"$namecuts".txt
  
  ## Save Patch to (amidi) SysEx file:
  amidi -p hw:2,0,0 -S "F0 $man 00 $mod 29 F7" -r $dirname/"$namecuts".b3x -t 0.3

if [ ! -e "$dirname/$bankname" ]; then
  mkdir $dirname/$bankname; 
fi  

#access=($dirname/$bankname)
#echo $access
### does not write it into directory. ????
#  amidi -p hw:2,0,0 -S "F0 $man 00 $mod 09 00 00 $varh F7" -r $access/"$namecuts".b3y -t 0.3
  amidi -p hw:2,0,0 -S "F0 $man 00 $mod 09 00 00 $varh F7" -r $dirname/"$cccuth""_""$namecuts".b3y -t 0.3




## Save Patch to a .b3p file. Need to reverse engineering the messages first.
## "F0 $man 00 $mod 09 00 00 $varh F7" or/and "F0 $man 00 $mod 29 F7"

echo "<?xml version="1.0" encoding="UTF-8"?>" > $dirname/"$namecuts".b3p
echo "" >> $dirname/"$namecuts".b3p
echo "<PatchData>" >> $dirname/"$namecuts".b3p
echo "  <Product>$mods</Product>" >> $dirname/"$namecuts".b3p
echo "  <Name>$namecuts</Name>" >> $dirname/"$namecuts".b3p
echo "  <Tooltip></Tooltip>" >> $dirname/"$namecuts".b3p
echo "  <Version>$vers</Version>" >> $dirname/"$namecuts".b3p
echo "  <Module0>" >> $dirname/"$namecuts".b3p
echo "    <Prm0></Prm0>" >> $dirname/"$namecuts".b3p
echo "    <Prm1></Prm1>" >> $dirname/"$namecuts".b3p
echo "    <Prm2></Prm2>" >> $dirname/"$namecuts".b3p
echo "    <Prm3></Prm3>" >> $dirname/"$namecuts".b3p
echo "    <Prm4></Prm4>" >> $dirname/"$namecuts".b3p
echo "    <Prm5></Prm5>" >> $dirname/"$namecuts".b3p
echo "    <Prm6></Prm6>" >> $dirname/"$namecuts".b3p
echo "    <Prm7></Prm7>" >> $dirname/"$namecuts".b3p
echo "    <Prm8></Prm8>" >> $dirname/"$namecuts".b3p
echo "    <Prm9></Prm9>" >> $dirname/"$namecuts".b3p
echo "    <Prm10></Prm10>" >> $dirname/"$namecuts".b3p
echo "  </Module0>" >> $dirname/"$namecuts".b3p
echo "  <Module1>" >> $dirname/"$namecuts".b3p
echo "    <Prm0></Prm0>" >> $dirname/"$namecuts".b3p
echo "    <Prm1></Prm1>" >> $dirname/"$namecuts".b3p
echo "    <Prm2></Prm2>" >> $dirname/"$namecuts".b3p
echo "    <Prm3></Prm3>" >> $dirname/"$namecuts".b3p
echo "    <Prm4></Prm4>" >> $dirname/"$namecuts".b3p
echo "    <Prm5></Prm5>" >> $dirname/"$namecuts".b3p
echo "    <Prm6></Prm6>" >> $dirname/"$namecuts".b3p
echo "    <Prm7></Prm7>" >> $dirname/"$namecuts".b3p
echo "    <Prm8></Prm8>" >> $dirname/"$namecuts".b3p
echo "    <Prm9></Prm9>" >> $dirname/"$namecuts".b3p
echo "    <Prm10></Prm10>" >> $dirname/"$namecuts".b3p
echo "  </Module1>" >> $dirname/"$namecuts".b3p
echo "  <Module2>" >> $dirname/"$namecuts".b3p
echo "    <Prm0></Prm0>" >> $dirname/"$namecuts".b3p
echo "    <Prm1></Prm1>" >> $dirname/"$namecuts".b3p
echo "    <Prm2></Prm2>" >> $dirname/"$namecuts".b3p
echo "    <Prm3></Prm3>" >> $dirname/"$namecuts".b3p
echo "    <Prm4></Prm4>" >> $dirname/"$namecuts".b3p
echo "    <Prm5></Prm5>" >> $dirname/"$namecuts".b3p
echo "    <Prm6></Prm6>" >> $dirname/"$namecuts".b3p
echo "    <Prm7></Prm7>" >> $dirname/"$namecuts".b3p
echo "    <Prm8></Prm8>" >> $dirname/"$namecuts".b3p
echo "    <Prm9></Prm9>" >> $dirname/"$namecuts".b3p
echo "    <Prm10></Prm10>" >> $dirname/"$namecuts".b3p
echo "  </Module2>" >> $dirname/"$namecuts".b3p
echo "  <Module3>" >> $dirname/"$namecuts".b3p
echo "    <Prm0></Prm0>" >> $dirname/"$namecuts".b3p
echo "    <Prm1></Prm1>" >> $dirname/"$namecuts".b3p
echo "    <Prm2></Prm2>" >> $dirname/"$namecuts".b3p
echo "    <Prm3></Prm3>" >> $dirname/"$namecuts".b3p
echo "    <Prm4></Prm4>" >> $dirname/"$namecuts".b3p
echo "    <Prm5></Prm5>" >> $dirname/"$namecuts".b3p
echo "    <Prm6>0</Prm6>" >> $dirname/"$namecuts".b3p
echo "    <Prm7></Prm7>" >> $dirname/"$namecuts".b3p
echo "    <Prm8>0</Prm8>" >> $dirname/"$namecuts".b3p
echo "    <Prm9>0</Prm9>" >> $dirname/"$namecuts".b3p
echo "    <Prm10>0</Prm10>" >> $dirname/"$namecuts".b3p
echo "  </Module3>" >> $dirname/"$namecuts".b3p
echo "  <Module4>" >> $dirname/"$namecuts".b3p
echo "    <Prm0>0</Prm0>" >> $dirname/"$namecuts".b3p
echo "    <Prm1>0</Prm1>" >> $dirname/"$namecuts".b3p
echo "    <Prm2>0</Prm2>" >> $dirname/"$namecuts".b3p
echo "    <Prm3>0</Prm3>" >> $dirname/"$namecuts".b3p
echo "    <Prm4>0</Prm4>" >> $dirname/"$namecuts".b3p
echo "    <Prm5>0</Prm5>" >> $dirname/"$namecuts".b3p
echo "    <Prm6>0</Prm6>" >> $dirname/"$namecuts".b3p
echo "    <Prm7>0</Prm7>" >> $dirname/"$namecuts".b3p
echo "    <Prm8>0</Prm8>" >> $dirname/"$namecuts".b3p
echo "    <Prm9>0</Prm9>" >> $dirname/"$namecuts".b3p
echo "    <Prm10>0</Prm10>" >> $dirname/"$namecuts".b3p
echo "  </Module4>" >> $dirname/"$namecuts".b3p
echo "</PatchData>" >> $dirname/"$namecuts".b3p



  ## Save complete bank to an own .xml-file-structure:
  ## 

done



## Jump back to last patch used
amidi -p hw:2,0,0 -S "$poscut"

sleep 0.3
## Lock device again:
amidi -p hw:2,0,0 -S "F0 $man 00 $mod 51 F7"
