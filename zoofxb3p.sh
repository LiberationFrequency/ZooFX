#!/bin/bash

## Proof of concept, how to read in a .b3p-file and transmit it to the ZFXB3. Not ready yet.
## e.g.
## ./zoofxb3p.sh -f /path/to/filename.b3p

## known issues:
## accept only values between 0 - 127. Comes into conflict with Total PATCH LEVEL/Tempo/and maybe some patches.
## sometimes it handles the patchnames incorrectly. A Problem with space characters.
## Easy to understand, but too much code. Reduce it!
## Early alpha version. Absolutly no warranty! 

#set -e -u


# Parse arguments
usage() {
    echo "Usage: $0 [-h] [-v] [-f FILE]"
    echo "  -b  *Not implemented yet* Add on. Select bank. (A0 - J9)" # invalid character -
    echo "  -f  Specify a .b3p-file and transmit config to device."
    echo "  -h  Help. Display this message and quit."
    echo "  -p  Add on. Flip signal chain path forward/backward. (0 / 1)"
    echo "  -r  Add on. Reset changes from the preset and quit. Works from time to time." #(?Not inside Total-/Globalmodus)
    echo "  -t  *Not implemented yet* Add on. Define Tempo."
    echo "  -v  Version. Print version number and quit."
    exit
}

bank=""
#optspec="fhrv:"
#optspec="hvrf:"
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
	    amidi -p hw:2 -S "C0 $varc" >&2
	    exit 1
            ;;
        f)
            file=${OPTARG}
            ;;
        h)
            usage
            ;;
        p)  path=${OPTARG}
	    amidi -p hw:2 -S "F0 52 00 4F 50 F7" && amidi -p hw:2 -S "F0 52 00 4F 31 03 09 $path 00 F7" && amidi -p hw:2 -S "F0 52 00 4F 51 F7" >&2
            exit 1
            ;;
        r)
            amidi -p hw:2 -S "F0 52 00 4F 51 F7" >&2
            exit 1
            ;;
        v)
            echo "0.00.001 alpha" >&2
            exit 1
            ;;
        *)
            usage
            ;;
    esac
done



prod=$(xmlstarlet sel -t -v "(/PatchData/Product)" -n "$2")

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


## Unlock device
amidi -p hw:2 -S "F0 52 00 $mod 50 F7" -i 0.2


#bankd=$(echo "ibase=16; $bank" | bc) 
#bankk=160
#banks=$(($bankd-$bankk)) 
#amidi -p hw:2 -S "C0 $banks" >&2




## Patchname
name=$(xmlstarlet sel -t -v "(/PatchData/Name)" -n "$2")
n0=("${name:0:1} ${name:10}")
n0h=$(echo -n "$n0" | od -A n -t x1)
amidi -p hw:2 -S "F0 52 00 $mod 31 04 00 $n0h 00 F7" -i 0.2

n1=("${name:1:1} ${name:10}")
n1h=$(echo -n "$n1" | od -A n -t x1)
amidi -p hw:2 -S "F0 52 00 $mod 31 04 01 $n1h 00 F7" -i 0.2

n2=("${name:2:1} ${name:10}")
n2h=$(echo -n "$n2" | od -A n -t x1)
amidi -p hw:2 -S "F0 52 00 $mod 31 04 02 $n2h 00 F7" -i 0.2

n3=("${name:3:1} ${name:10}")
n3h=$(echo -n "$n3" | od -A n -t x1)
amidi -p hw:2 -S "F0 52 00 $mod 31 04 03 $n3h 00 F7" -i 0.2

n4=("${name:4:1} ${name:10}")
n4h=$(echo -n "$n4" | od -A n -t x1)
amidi -p hw:2 -S "F0 52 00 $mod 31 04 04 $n4h 00 F7" -i 0.2

n5=("${name:5:1} ${name:10}")
n5h=$(echo -n "$n5" | od -A n -t x1)
amidi -p hw:2 -S "F0 52 00 $mod 31 04 05 $n5h 00 F7" -i 0.2

n6=("${name:6:1} ${name:10}")
n6h=$(echo -n "$n6" | od -A n -t x1)
amidi -p hw:2 -S "F0 52 00 $mod 31 04 06 $n6h 00 F7" -i 0.2

n7=("${name:7:1} ${name:10}")
n7h=$(echo -n "$n7" | od -A n -t x1)
amidi -p hw:2 -S "F0 52 00 $mod 31 04 07 $n7h 00 F7" -i 0.2

n8=("${name:8:1} ${name:10}")
n8h=$(echo -n "$n8" | od -A n -t x1)
amidi -p hw:2 -S "F0 52 00 $mod 31 04 08 $n8h 00 F7" -i 0.2

n9=("${name:9:1} ${name:10}")
n9h=$(echo -n "$n9" | od -A n -t x1)
amidi -p hw:2 -S "F0 52 00 $mod 31 04 09 $n9h 00 F7" -i 0.2


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
sleep 5.2
## Lock device again:
amidi -p hw:2 -S "F0 52 00 $mod 51 F7"

# ...
# to be continued...