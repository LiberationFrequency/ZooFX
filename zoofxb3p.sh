#!/bin/bash

#set -e -u

## Proof of concept, how to read in a .b3p-file and transmit it to the ZFXB3. Not ready yet.
## e.g.
## ./zoofxb3p.sh -f /path/to/filename.b3p 

## known issues:
## accept only values between 0 - 127. Comes into conflict with Total PATCH LEVEL/Tempo/and maybe some patches.
## The select bank option works only upto F9. 
## All commands must be send seperate in this configuration or && . In the other configuration you must send all together.  
## Debug display name!
## Easy to understand, but too much code. Reduce it!
 

# Parse arguments
usage() {
    echo "Usage: $0 [-h] [-v] [-b bank] [-f /path/to/file.b3p]"
    echo "  -b  Add on. Select bank. (A0 - J9)" Need capital letters. # invalid character -
    echo "  -f  Specify a .b3p-file and transmit config to device."
    echo "  -h  Help. Display this message and quit."
    echo "  -p  Add on. Flip signal chain path forward/backward. (0 / 1)"
    echo "  -r  Add on. Reset changes from the preset and quit. Works from time to time." #(?Not inside Total-/Globalmodus)
    echo "  -t  *Not implemented yet* Add on. Define Tempo."
    echo "  -v  Version. Print version number and quit."
    exit
}

bank=""
optspec="b:hvrfp:"
while getopts "$optspec" optchar
do
    case "${optchar}" in
        b)
            bank="$OPTARG"
            echo $bank
	    bankd=$(echo "ibase=16; $bank" | bc)
            echo "bankd: $bankd" 
            banks=$(($bankd-(0xA0)))
            echo "banks: $banks"
            varc=$(echo 16o${banks}p |dc)
            echo "varc: $varc"
	    varh=$(echo 16o${varc}p |dc)
	    echo "varh: $varh"
	    amidi -p hw:2 -S "C0 $varh"
	    exit 1
	    ;;
        f)
            file=$"{OPTARG}"
            ;;
        h)
            usage
            ;;
        p)  
            path=${OPTARG}
	    amidi -p hw:2 -S "F0 52 00 4F 50 F7" && amidi -p hw:2 -S "F0 52 00 4F 31 03 09 $path 00 F7" && amidi -p hw:2 -S "F0 52 00 4F 51 F7" >&2
            exit 1
            ;;
        r)
            amidi -p hw:2 -S "F0 52 00 4F 51 F7" >&2
            exit 1
            ;;
        v)
            echo "0.00.004 alpha" >&2
            exit
            ;;
        *)
            usage
            ;;
    esac
done


#################################
#bank=$(echo "$2")
#echo $bank
#bankd=$(echo "ibase=16; $bank" | bc)
#echo "bankd: $bankd" 
#banks=$(($bankd-(0xA0)))
#echo "banks: $banks"
#varc=$(echo 16o${banks}p |dc)
#echo "varc: $varc"
#varh=$(echo 16o${varc}p |dc)
#echo "varh: $varh"
#amidi -p hw:2 -S "C0 $varh" 
##################################


prod=$(xmlstarlet sel -t -v "(/PatchData/Product)" -n "$2")
#echo $prod

case "$prod" in
        B3) mod=4F
            ;;
#        G3n) mod=59
#            ;;
#        B2) mod=??
#            ;;
#        G5) mod=??
#            ;;
        *) echo "Device is not supported."
           exit 1
            ;;
esac

#echo $mod




## Unlock device
amidi -p hw:2 -S "F0 52 00 $mod 50 F7" -i 0.2

####################
#flip=$(echo "$6")
#echo $flip
#amidi -p hw:2 -S "F0 52 00 $mod 31 03 09 $flip 00 F7" -i 0.2
####################

## Patchname
pname=$(xmlstarlet sel -t -v "(/PatchData/Name)" -n "$2")
echo $pname

pname0=("${pname:0:1}")
echo "pname0: "$pname0""
pname0h=$(echo -n "$pname0" | od -A n -t x1)
echo "$pname0h"
case "" in "$pname0h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 00 20 00 F7" -i 0.2;; esac 
#case "2a" in "$pname1h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 00 20 00 F7" -i 0.2;; esac 
#case "*" in "$pname0h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 00 $pname1h 00 F7" -i 0.2;; esac 
#if [ "$pname0h" == "2a" ] 
if [ $pname0h == "2a" ]
then
amidi -p hw:2 -S "F0 52 00 $mod 31 04 00 20 00 F7" -i 0.2
#elif [ "$pname0h" == "" ]
#then
#amidi -p hw:2 -S "F0 52 00 $mod 31 04 00 20 00 F7" -i 0.2
else
echo "$pname0h"
amidi -p hw:2 -S "F0 52 00 $mod 31 04 00 $pname0h 00 F7" -i 0.2
fi


pname1=("${pname:1:1}")
echo "pname1: "$pname1""
pname1h=$(echo -n "$pname1" | od -A n -t x1)
echo "$pname1h"
case "" in "$pname1h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 01 20 00 F7" -i 0.2;; esac 
#case "2a" in "$pname1h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 01 20 00 F7" -i 0.2;; esac 
#case "*" in "$pname1h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 01 $pname1h 00 F7" -i 0.2;; esac 
#if [ "$pname1h" == "2a" ] 
if [ $pname1h == "2a" ]
then
amidi -p hw:2 -S "F0 52 00 $mod 31 04 01 20 00 F7" -i 0.2
#elif [ "$pname1h" == "" ]
#then
#amidi -p hw:2 -S "F0 52 00 $mod 31 04 01 20 00 F7" -i 0.2
else
echo "$pname1h"
amidi -p hw:2 -S "F0 52 00 $mod 31 04 01 $pname1h 00 F7" -i 0.2
fi


pname2=("${pname:2:1}")
echo "pname2: "$pname2""
pname2h=$(echo -n "$pname2" | od -A n -t x1)
echo "$pname2h"
case "" in "$pname2h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 02 20 00 F7" -i 0.2;; esac 
#case "2a" in "$pname2h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 02 20 00 F7" -i 0.2;; esac 
#case "*" in "$pname2h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 02 $pname2h 00 F7" -i 0.2;; esac 
#if [ "$pname2h" == "2a" ] 
if [ $pname2h == "2a" ]
then
amidi -p hw:2 -S "F0 52 00 $mod 31 04 02 20 00 F7" -i 0.2
#elif [ "$pname2h" == "" ]
#then
#amidi -p hw:2 -S "F0 52 00 $mod 31 04 02 20 00 F7" -i 0.2
else
echo "$pname2h"
amidi -p hw:2 -S "F0 52 00 $mod 31 04 02 $pname2h 00 F7" -i 0.2
fi


pname3=("${pname:3:1}")
echo "pname3: "$pname3""
pname3h=$(echo -n "$pname3" | od -A n -t x1)
echo "$pname3h"
case "" in "$pname3h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 03 20 00 F7" -i 0.2;; esac 
#case "2a" in "$pname3h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 03 20 00 F7" -i 0.2;; esac 
#case "*" in "$pname3h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 03 $pname3h 00 F7" -i 0.2;; esac 
#if [ "$pname3h" == "2a" ] 
if [ $pname3h == "2a" ]
then
amidi -p hw:2 -S "F0 52 00 $mod 31 04 03 20 00 F7" -i 0.2
#elif [ "$pname3h" == "" ]
#then
#amidi -p hw:2 -S "F0 52 00 $mod 31 04 03 20 00 F7" -i 0.2
else
echo "$pname3h"
amidi -p hw:2 -S "F0 52 00 $mod 31 04 03 $pname3h 00 F7" -i 0.2
fi


pname4=("${pname:4:1}")
echo "pname4: "$pname4""
pname4h=$(echo -n "$pname4" | od -A n -t x1)
echo "$pname4h"
case "" in "$pname4h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 04 20 00 F7" -i 0.2;; esac 
#case "2a" in "$pname4h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 04 20 00 F7" -i 0.2;; esac 
#case "*" in "$pname4h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 04 $pname4h 00 F7" -i 0.2;; esac 
#if [ "$pname4h" == "2a" ] 
if [ $pname4h == "2a" ]
then
amidi -p hw:2 -S "F0 52 00 $mod 31 04 04 20 00 F7" -i 0.2
#elif [ "$pname4h" == "" ]
#then
#amidi -p hw:2 -S "F0 52 00 $mod 31 04 04 20 00 F7" -i 0.2
else
echo "$pname4h"
amidi -p hw:2 -S "F0 52 00 $mod 31 04 04 $pname4h 00 F7" -i 0.2
fi


pname5=("${pname:5:1}")
echo "pname5: "$pname5""
pname5h=$(echo -n "$pname5" | od -A n -t x1)
echo "$pname5h"
case "" in "$pname5h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 05 20 00 F7" -i 0.2;; esac 
#case "2a" in "$pname5h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 05 20 00 F7" -i 0.2;; esac 
#case "*" in "$pname5h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 05 $pname5h 00 F7" -i 0.2;; esac 
#if [ "$pname5h" == "2a" ] 
if [ $pname5h == "2a" ]
then
amidi -p hw:2 -S "F0 52 00 $mod 31 04 05 20 00 F7" -i 0.2
#elif [ "$pname5h" == "" ]
#then
#amidi -p hw:2 -S "F0 52 00 $mod 31 04 05 20 00 F7" -i 0.2
else
echo "$pname5h"
amidi -p hw:2 -S "F0 52 00 $mod 31 04 05 $pname5h 00 F7" -i 0.2
fi


pname6=("${pname:6:1}")
echo "pname6: "$pname6""
pname6h=$(echo -n "$pname6" | od -A n -t x1)
echo "$pname6h"
case "" in "$pname6h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 06 20 00 F7" -i 0.2;; esac 
#case "2a" in "$pname6h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 06 20 00 F7" -i 0.2;; esac 
#case "*" in "$pname6h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 06 $pname6h 00 F7" -i 0.2;; esac 
#if [ "$pname6h" == "2a" ] 
if [ $pname6h == "2a" ]
then
amidi -p hw:2 -S "F0 52 00 $mod 31 04 06 20 00 F7" -i 0.2
#elif [ "$pname6h" == "" ]
#then
#amidi -p hw:2 -S "F0 52 00 $mod 31 04 06 20 00 F7" -i 0.2
else
echo "$pname6h"
amidi -p hw:2 -S "F0 52 00 $mod 31 04 06 $pname6h 00 F7" -i 0.2
fi


pname7=("${pname:7:1}")
echo "pname7: "$pname7""
pname7h=$(echo -n "$pname7" | od -A n -t x1)
echo "$pname7h"
case "" in "$pname7h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 07 20 00 F7" -i 0.2;; esac 
#case "2a" in "$pname7h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 07 20 00 F7" -i 0.2;; esac 
#case "*" in "$pname7h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 07 $pname7h 00 F7" -i 0.2;; esac 
#if [ "$pname7h" == "2a" ] 
if [ $pname7h == "2a" ]
then
amidi -p hw:2 -S "F0 52 00 $mod 31 04 07 20 00 F7" -i 0.2
#elif [ "$pname7h" == "" ]
#then
#amidi -p hw:2 -S "F0 52 00 $mod 31 04 07 20 00 F7" -i 0.2
else
echo "$pname7h"
amidi -p hw:2 -S "F0 52 00 $mod 31 04 07 $pname7h 00 F7" -i 0.2
fi


pname8=("${pname:8:1}")
echo "pname8: "$pname8""
pname8h=$(echo -n "$pname8" | od -A n -t x1)
echo "$pname8h"
case "" in "$pname8h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 08 20 00 F7" -i 0.2;; esac 
#case "2a" in "$pname8h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 08 20 00 F7" -i 0.2;; esac 
#case "*" in "$pname8h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 08 $pname8h 00 F7" -i 0.2;; esac 
#if [ "$pname8h" == "2a" ] 
if [ $pname8h == "2a" ]
then
amidi -p hw:2 -S "F0 52 00 $mod 31 04 08 20 00 F7" -i 0.2
#elif [ "$pname8h" == "" ]
#then
#amidi -p hw:2 -S "F0 52 00 $mod 31 04 08 20 00 F7" -i 0.2
else
echo "$pname8h"
amidi -p hw:2 -S "F0 52 00 $mod 31 04 08 $pname8h 00 F7" -i 0.2
fi


pname9=("${pname:9:1}")
echo "pname9: "$pname9""
pname9h=$(echo -n "$pname9" | od -A n -t x1)
echo "$pname9h"
case "" in "$pname9h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 09 20 00 F7" -i 0.2;; esac 
#case "2a" in "$pname9h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 09 20 00 F7" -i 0.2;; esac 
#case "*" in "$pname9h") amidi -p hw:2 -S "F0 52 00 $mod 31 04 09 $pname9h 00 F7" -i 0.2;; esac 
#if [ "$pname9h" == "2a" ] 
if [ $pname9h == "2a" ]
then
amidi -p hw:2 -S "F0 52 00 $mod 31 04 09 20 00 F7" -i 0.2
#elif [ "$pname9h" == "" ]
#then
#amidi -p hw:2 -S "F0 52 00 $mod 31 04 09 20 00 F7" -i 0.2
else
echo "$pname9h"
amidi -p hw:2 -S "F0 52 00 $mod 31 04 09 $pname9h 00 F7" -i 0.2
fi


#### Effect slots and Pedal-/Switchassignment
## Module 0:
m0p0=$(xmlstarlet sel -t -v "(/PatchData/Module0/Prm0)" -n "$2")
amidi -p hw:2 -S "f0 52 00 $mod 31 00 00 $m0p0 00 f7" -i 0.2

m0p1=$(xmlstarlet sel -t -v "(/PatchData/Module0/Prm1)" -n "$2")
m0p1h=$(echo "obase=16; $m0p1" | bc)
amidi -p hw:2 -S "f0 52 00 $mod 31 00 01 $m0p1h 00 f7" -i 0.2

m0p2=$(xmlstarlet sel -t -v "(/PatchData/Module0/Prm2)" -n "$2")
m0p2h=$(echo "obase=16; $m0p2" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 00 02 $m0p2h 00 F7" -i 0.2

m0p3=$(xmlstarlet sel -t -v "(/PatchData/Module0/Prm3)" -n "$2")
m0p3h=$(echo "obase=16; $m0p3" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 00 03 $m0p3h 00 F7" -i 0.2

m0p4=$(xmlstarlet sel -t -v "(/PatchData/Module0/Prm4)" -n "$2")
m0p4h=$(echo "obase=16; $m0p4" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 00 04 $m0p4h 00 F7" -i 0.2

m0p5=$(xmlstarlet sel -t -v "(/PatchData/Module0/Prm5)" -n "$2")
m0p5h=$(echo "obase=16; $m0p5" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 00 05 $m0p5h 00 F7" -i 0.2

m0p6=$(xmlstarlet sel -t -v "(/PatchData/Module0/Prm6)" -n "$2")
m0p6h=$(echo "obase=16; $m0p6" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 00 06 $m0p6h 00 F7" -i 0.2

m0p7=$(xmlstarlet sel -t -v "(/PatchData/Module0/Prm7)" -n "$2")
m0p7h=$(echo "obase=16; $m0p7" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 00 07 $m0p7h 00 F7" -i 0.2

m0p8=$(xmlstarlet sel -t -v "(/PatchData/Module0/Prm8)" -n "$2")
m0p8h=$(echo "obase=16; $m0p8" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 00 08 $m0p8h 00 F7" -i 0.2

m0p9=$(xmlstarlet sel -t -v "(/PatchData/Module0/Prm9)" -n "$2")
m0p9h=$(echo "obase=16; $m0p9" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 00 09 $m0p9h 00 F7" -i 0.2

m0p10=$(xmlstarlet sel -t -v "(/PatchData/Module0/Prm10)" -n "$2")
m0p10h=$(echo "obase=16; $m0p10" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 00 0A $m0p10h 00 F7" -i 0.2


## Module 1:
m1p0=$(xmlstarlet sel -t -v "(/PatchData/Module1/Prm0)" -n "$2")
amidi -p hw:2 -S "F0 52 00 $mod 31 01 00 $m1p0 00 F7" -i 0.2

m1p1=$(xmlstarlet sel -t -v "(/PatchData/Module1/Prm1)" -n "$2")
m1p1h=$(echo "obase=16; $m1p1" | bc)
amidi -p hw:2 -S "f0 52 00 $mod 31 01 01 $m1p1h 00 f7" -i 0.2

m1p2=$(xmlstarlet sel -t -v "(/PatchData/Module1/Prm2)" -n "$2")
m1p2h=$(echo "obase=16; $m1p2" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 01 02 $m1p2h 00 F7" -i 0.2

m1p3=$(xmlstarlet sel -t -v "(/PatchData/Module1/Prm3)" -n "$2")
m1p3h=$(echo "obase=16; $m1p3" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 01 03 $m1p3h 00 F7" -i 0.2

m1p4=$(xmlstarlet sel -t -v "(/PatchData/Module1/Prm4)" -n "$2")
m1p4h=$(echo "obase=16; $m1p4" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 01 04 $m1p4h 00 F7" -i 0.2

m1p5=$(xmlstarlet sel -t -v "(/PatchData/Module1/Prm5)" -n "$2")
m1p5h=$(echo "obase=16; $m1p5" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 01 05 $m1p5h 00 F7" -i 0.2

m1p6=$(xmlstarlet sel -t -v "(/PatchData/Module1/Prm6)" -n "$2")
m1p6h=$(echo "obase=16; $m1p6" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 01 06 $m1p6h 00 F7" -i 0.2

m1p7=$(xmlstarlet sel -t -v "(/PatchData/Module1/Prm7)" -n "$2")
m1p7h=$(echo "obase=16; $m1p7" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 01 07 $m1p7h 00 F7" -i 0.2

m1p8=$(xmlstarlet sel -t -v "(/PatchData/Module1/Prm8)" -n "$2")
m1p8h=$(echo "obase=16; $m1p8" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 01 08 $m1p8h 00 F7" -i 0.2

m1p9=$(xmlstarlet sel -t -v "(/PatchData/Module1/Prm9)" -n "$2")
m1p9h=$(echo "obase=16; $m1p9" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 01 09 $m1p9h 00 F7" -i 0.2

m1p10=$(xmlstarlet sel -t -v "(/PatchData/Module1/Prm10)" -n "$2")
m1p10h=$(echo "obase=16; $m1p10" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 01 0A $m1p10h 00 F7" -i 0.2


## Module2:
m2p0=$(xmlstarlet sel -t -v "(/PatchData/Module2/Prm0)" -n "$2")
amidi -p hw:2 -S "f0 52 00 $mod 31 02 00 $m2p0 00 f7" -i 0.2

m2p1=$(xmlstarlet sel -t -v "(/PatchData/Module2/Prm1)" -n "$2")
m2p1h=$(echo "obase=16; $m2p1" | bc)
amidi -p hw:2 -S "f0 52 00 $mod 31 02 01 $m2p1h 00 f7" -i 0.2

m2p2=$(xmlstarlet sel -t -v "(/PatchData/Module2/Prm2)" -n "$2")
m2p2h=$(echo "obase=16; $m2p2" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 02 02 $m2p2h 00 F7" -i 0.2

m2p3=$(xmlstarlet sel -t -v "(/PatchData/Module2/Prm3)" -n "$2")
m2p3h=$(echo "obase=16; $m2p3" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 02 03 $m2p3h 00 F7" -i 0.2

m2p4=$(xmlstarlet sel -t -v "(/PatchData/Module2/Prm4)" -n "$2")
m2p4h=$(echo "obase=16; $m2p4" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 02 04 $m2p4h 00 F7" -i 0.2

m2p5=$(xmlstarlet sel -t -v "(/PatchData/Module2/Prm5)" -n "$2")
m2p5h=$(echo "obase=16; $m2p5" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 02 05 $m2p5h 00 F7" -i 0.2

m2p6=$(xmlstarlet sel -t -v "(/PatchData/Module2/Prm6)" -n "$2")
m2p6h=$(echo "obase=16; $m2p6" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 02 06 $m2p6h 00 F7" -i 0.2

m2p7=$(xmlstarlet sel -t -v "(/PatchData/Module2/Prm7)" -n "$2")
m2p7h=$(echo "obase=16; $m2p7" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 02 07 $m2p7h 00 F7" -i 0.2

m2p8=$(xmlstarlet sel -t -v "(/PatchData/Module2/Prm8)" -n "$2")
m2p8h=$(echo "obase=16; $m2p8" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 02 08 $m2p8h 00 F7" -i 0.2

m2p9=$(xmlstarlet sel -t -v "(/PatchData/Module2/Prm9)" -n "$2")
m2p9h=$(echo "obase=16; $m2p9" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 02 09 $m2p9h 00 F7" -i 0.2

m2p10=$(xmlstarlet sel -t -v "(/PatchData/Module2/Prm10)" -n "$2")
m2p10h=$(echo "obase=16; $m2p10" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 02 0A $m2p10h 00 F7" -i 0.2


## Module3 - Total modus adjustments
m3p0=$(xmlstarlet sel -t -v "(/PatchData/Module3/Prm0)" -n "$2")
m3p0h=$(echo "obase=16; $m3p0" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 03 02 $m3p0h 00 F7" -i 0.2

## CTRL SW(1) assign /0=no/1=FX1/2=FX2/3=FX3/4=TapTempo/5=Bypass/Mute
m3p1=$(xmlstarlet sel -t -v "(/PatchData/Module3/Prm1)" -n "$2")
#m3p1h=$(echo "obase=16; $m3p1" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 03 06 $m3p1 00 F7" -i 0.2

## CTRL SW(2) assign - if a preset (m3p1) has more than one Option
m3p2=$(xmlstarlet sel -t -v "(/PatchData/Module3/Prm2)" -n "$2")
#m3p2h=$(echo "obase=16; $m3p2" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 03 07 $m3p2 00 F7" -i 0.2

## CTRL PDL DEST
m3p3=$(xmlstarlet sel -t -v "(/PatchData/Module3/Prm3)" -n "$2")
amidi -p hw:2 -S "F0 52 00 $mod 31 03 03 00 $m3p3 F7" -i 0.2
																	        
m3p4=$(xmlstarlet sel -t -v "(/PatchData/Module3/Prm4)" -n "$2")
m3p4h=$(echo "obase=16; $m3p4" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 03 04 $m3p4h 00 F7" -i 0.2

m3p5=$(xmlstarlet sel -t -v "(/PatchData/Module3/Prm5)" -n "$2")
m3p5h=$(echo "obase=16; $m3p5" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 03 05 $m3p5h 00 F7" -i 0.2

#m3p6=$(xmlstarlet sel -t -v "(/PatchData/Module3/Prm6)" -n "$2")
#m3p6h=$(echo "obase=16; $m3p6" | bc)
#amidi -p hw:2 -S "F0 52 00 $mod 31 03 06 $m3p6h 00 F7" -i 0.2

m3p7=$(xmlstarlet sel -t -v "(/PatchData/Module3/Prm7)" -n "$2")
m3p7h=$(echo "obase=16; $m3p7" | bc)
amidi -p hw:2 -S "F0 52 00 $mod 31 03 0A $m3p7h 00 F7" -i 0.2

#m3p8=$(xmlstarlet sel -t -v "(/PatchData/Module3/Prm8)" -n "$2")
#m3p8h=$(echo "obase=16; $m3p8" | bc)
#amidi -p hw:2 -S "F0 52 00 $mod 31 03 08 $m3p8h 00 F7" -i 0.2

#m3p9=$(xmlstarlet sel -t -v "(/PatchData/Module3/Prm9)" -n "$2")
#m3p9h=$(echo "obase=16; $m3p9" | bc)
#amidi -p hw:2 -S "F0 52 00 $mod 31 03 02 $m3p9h 00 F7" -i 0.2

#m3p10=$(xmlstarlet sel -t -v "(/PatchData/Module3/Prm10)" -n "$2")
#m3p10h=$(echo "obase=16; $m3p10" | bc)
#amidi -p hw:2 -S "F0 52 00 $mod 31 03 0A $m3p10h 00 F7" -i 0.2


#m4p0
#??? I've never seen a .b3p-file that uses Module4, maybe for a another Version or a hidden feature.
# at the moment only interesting for potential checksum calculations.

## Wait (for too long), but otherwise the Patch will reverse and the message not accepted.
## Or let the device open. 
sleep 5.3
## Lock device again:
amidi -p hw:2 -S "F0 52 00 $mod 51 F7"

echo ""
echo "done..."
# ...
# to be continued...