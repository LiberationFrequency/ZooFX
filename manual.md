
Explanation:  
Preset = The effect itself, integrated in the firmware.  
Patch = The whole configuration of one signal chain, etc. you edited.  
Bank = The whole storage of max. 100 patches. (A0-J9)  

FYI: amidi -hw:2 can directed to other ports in other setups.  

Not complete yet... to be continued...  


Structure of a System Exclusiv (SysEx) message:  
F0 52 00 4F 31 01 00 00 00 F7

F0 = SysEx Startbyte  
52 = Manufacturer identifier, in this case Zoom®  
00 = Device ID  
4F = Model identifier, in this case B3  
.. = the proper message  
00 = ?Checksum if necessary?  
F7 = SysEx Endbyte  



(Un)Lock and requests:  
-----------------------------------------------
Unlock device:  
amidi -p hw:2 -S "F0 52 00 4F 50 F7"  

Lock device again:  
amidi -p hw:2 -S "F0 52 00 4F 51 F7"  
If the device is locked, the patch will be reset. Does not work for adjustments inside the totalmodus.  

Request current position in bank:  
amidi -p hw:2 -S "F0 52 00 4F 33 F7"  

Request the current patch configuration:  
amidi -p hw:2 -S "F0 52 00 4F 29 F7"  


Change the preset:  
-----------------------------------------------
... as Control Change Messages:  
A0 = amidi -p hw:2 -S "C0 00"  
A1 = amidi -p hw:2 -S "C0 01"  
A2 = amidi -p hw:2 -S "C0 02"  
A9 = amidi -p hw:2 -S "C0 09"  
B0 = amidi -p hw:2 -S "C0 0A"  
B1 = amidi -p hw:2 -S "C0 0B"  
...  
D1 = amidi -p hw:2 -S "C0 1F"  
... and so on in hexadecimal up to  
J9 = amidi -p hw:2 -S "C0 63"  

... or as SysEx Message:  
amidi -p hw:2 -S "F0 52 00 4F 32 C0 xx F7"  


Stompbar:  
------------------------------------------------- 
Turning-off left effect (Module0):  
amidi -p hw:2 -S "F0 52 00 4F 31 00 00 00 00 F7"  
turning-on ...:            
amidi -p hw:2 -S "F0 52 00 4F 31 00 00 01 00 F7"  


Turning-off middle effect (Module1):  
amidi -p hw:2 -S "F0 52 00 4F 31 01 00 00 00 F7"  
turning-on ...:            
amidi -p hw:2 -S "F0 52 00 4F 31 01 00 01 00 F7"  

Turning-off right effect (Module2):  
amidi -p hw:2 -S "F0 52 00 4F 31 02 00 00 00 F7"  
turning-on ...:            
amidi -p hw:2 -S "F0 52 00 4F 31 02 00 01 00 F7"  



Change Preset directly:
--------------------------------------------------
(09 = Bit Crush)  
Left (Module0):  
amidi -p hw:2 -S "F0 52 00 4f 31 00 01 09 00 f7"  

Middle (Module1):  
amidi -p hw:2 -S "F0 52 00 4f 31 01 01 09 00 f7"  

Right (Module2):  
amidi -p hw:2 -S "F0 52 00 4f 31 02 01 09 00 f7"  


Sort it like in the firmware!:  
D Comp:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "F0 52 00 4F 31 02 01 10 00 F7"  
M Comp:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "F0 52 00 4F 31 02 01 11 00 F7"  
DualComp:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "F0 52 00 4F 31 02 01 44 00 F7"  
Slow Attck:&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "F0 52 00 4F 31 02 01 12 00 F7"  
ZNR:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "f0 52 00 4f 31 02 01 13 00 f7"  
GraphicEQ:&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "F0 52 00 4F 31 02 01 14 00 F7"  
ParaEQ:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "F0 52 00 4F 31 02 01 15 00 F7"  
Splitter:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "F0 52 00 4F 31 02 01 47 00 F7"  
BottomB:  
Exciter:  
CombFLTR:&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "F0 52 00 4F 31 02 01 16 00 F7"  
AutoWah:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "F0 52 00 4F 31 02 01 17 00 F7"  
Z-Tron:		amidi -p hw:2 -S "F0 52 00 4F 31 02 01 18 00 F7"  
M-Filter:  
A-Filter:  
Step:		amidi -p hw:2 -S "F0 52 00 4F 31 02 01 19 00 F7"  
  
StereoCho:	amidi -p hw:2 -S "F0 52 00 4F 31 02 01 20 00 F7"  
  
  
Bit Crush: 	amidi -p hw:2 -S "F0 52 00 4F 31 02 01 09 00 F7"  
Bomber:		amidi -p hw:2 -S "F0 52 00 4F 31 02 01 0a 00 F7"  
  
M-Filter:	amidi -p hw:2 -S "F0 52 00 4F 31 02 01 01 00 F7"  
  
StdSyn:		amidi -p hw:2 -S "F0 52 00 4F 31 02 01 63 00 F7"  
Z-Syn:		amidi -p hw:2 -S "F0 52 00 4F 31 02 01 67 00 F7"  
Z-Organ:	amidi -p hw:2 -S "F0 52 00 4F 31 02 01 03 00 F7"  
Defret:		amidi -p hw:2 -S "F0 52 00 4F 31 02 01 68 00 F7"  
  
FilterDIY:	amidi -p hw:2 -S "F0 52 00 4F 31 02 01 06 00 F7"  
PitchDelay:	amidi -p hw:2 -S "F0 52 00 4F 31 02 01 07 00 F7"  
StereoDelay:	amidi -p hw:2 -S "F0 52 00 4F 31 02 01 08 00 F7"  	
PhaseDIY	amidi -p hw:2 -S "F0 52 00 4F 31 02 01 05 00 F7"  
Hall:		amidi -p hw:2 -S "F0 52 00 4F 31 02 01 31 00 F7"  
Room:		amidi -p hw:2 -S "F0 52 00 4F 31 02 01 32 00 F7"  
TiledRM:	amidi -p hw:2 -S "F0 52 00 4F 31 02 01 33 00 F7"  
Spring:		amidi -p hw:2 -S "F0 52 00 4F 31 02 01 34 00 F7"  
Arena Reverb:   amidi -p hw:2 -S "F0 52 00 4F 31 02 01 35 00 F7"   
EarlyReflection	amidi -p hw:2 -S "F0 52 00 4F 31 02 01 36 00 F7"  
Air:		amidi -p hw:2 -S "F0 52 00 4F 31 02 01 37 00 F7"  
  
PedalWah:	amidi -p hw:2 -S "F0 52 00 4F 31 02 01 69 00 F7"  
  
Slicer:		amidi -p hw:2 -S "F0 52 00 4F 31 02 01 04 00 F7"  
The Vibe:	amidi -p hw:2 -S "F0 52 00 4F 31 02 01 02 00 F7"  


Change Tempo:  
--------------------------------------------------------------------
x changes the value for 16 bpm, y for 1 bpm. If the value rise above 127, it counts z to 1 and xy change to zero.  
amidi -p hw:2 -S "F0 52 00 4F 31 03 08 xy 0z F7"  
  
40 BPM:  
amidi -p hw:2 -S "F0 52 00 4F 31 03 08 00 00 F7"  
amidi -p hw:2 -S "F0 52 00 4F 31 03 08 01 00 F7"  
100 BPM:  
amidi -p hw:2 -S "F0 52 00 4F 31 03 08 64 00 F7"  
120 BPM:  
amidi -p hw:2 -S "F0 52 00 4F 31 03 08 78 00 F7"  
128 BPM:  
amidi -p hw:2 -S "F0 52 00 4F 31 03 08 00 01 F7"  
129 BPM:  
amidi -p hw:2 -S "F0 52 00 4F 31 03 08 01 01 F7"  
152 BPM    
amidi -p hw:2 -S "F0 52 00 4F 31 03 08 18 01 F7"    
153 BPM   
amidi -p hw:2 -S "F0 52 00 4F 31 03 08 19 01 F7"  
168 BPM  
amidi -p hw:2 -S "F0 52 00 4F 31 03 08 28 01 F7"  
249 BPM:  
amidi -p hw:2 -S "F0 52 00 4F 31 03 08 79 01 F7"  
250 BPM:  
amidi -p hw:2 -S "F0 52 00 4F 31 03 08 7a 01 F7"  
amidi -p hw:2 -S "F0 52 00 4F 31 03 08 00 10 F7"  



Names:  
---------------------------------------------------
.. = F0 52 00 4F 31 04 xx yz 00 F7  
xx = Ten digits / 0-9  
yz = Character   

0123456789  
0 =  F0 52 00 4F 31 04 00 30 00 F7  
1 =  F0 52 00 4F 31 04 01 31 00 F7  
...  
9 =  F0 52 00 4F 31 04 09 39 00 F7  

ABC..Z  
A1 =  F0 52 00 4F 31 04 00 41 00 F7  
B2 =  F0 52 00 4F 31 04 01 42 00 F7  
C3 =  F0 52 00 4F 31 04 02 43 00 F7  
...  
Z10 = F0 52 00 4F 31 04 09 5A 00 F7  

abcdefg..z  
a =  F0 52 00 4F 31 04 00 61 00 F7  
z =  F0 52 00 4F 31 04 09 7A 00 F7  
  
Space  
     F0 52 00 4F 31 04 00 20 00 F7  

! =  F0 52 00 4F 31 04 00 21 00 F7  
(hash)# =  F0 52 00 4F 31 04 00 23 00 F7  
$ =  F0 52 00 4F 31 04 00 24 00 F7  
% =  F0 52 00 4F 31 04 00 25 00 F7  
& =  F0 52 00 4F 31 04 00 26 00 F7  
' =  F0 52 00 4F 31 04 00 27 00 F7  
( =  F0 52 00 4F 31 04 00 28 00 F7  
) =  F0 52 00 4F 31 04 00 29 00 F7  
(plus)+ =  F0 52 00 4F 31 04 00 2B 00 F7  
, =  F0 52 00 4F 31 04 00 2C 00 F7  
(dash)- =  F0 52 00 4F 31 04 00 2D 00 F7  
. =  F0 52 00 4F 31 04 00 2E 00 F7  
; =  F0 52 00 4F 31 04 00 3B 00 F7  
= =  F0 52 00 4F 31 04 00 3D 00 F7  
@ =  F0 52 00 4F 31 04 00 40 00 F7  
[ =  F0 52 00 4F 31 04 00 5B 00 F7  
] =  F0 52 00 4F 31 04 00 5D 00 F7  
^ =  F0 52 00 4F 31 04 00 5E 00 F7  
_ =  F0 52 00 4F 31 04 00 5F 00 F7  
` =  F0 52 00 4F 31 04 00 60 00 F7  
{ =  F0 52 00 4F 31 04 00 7B 00 F7  
} =  F0 52 00 4F 31 04 00 7D 00 F7  
~ =  F0 52 00 4F 31 04 00 7E 00 F7  

(xxx) = syntax compensation for now  



Revise and translate below this!!!  
-----------------------------------------

Knobs:  
-----------------------------------------
In short:    
F0 52 00 4F 31 00 02 05 00 F7  
F0 52 00 4F 31 02 07 2A 00 F7  
F0 52 00 4F 31 xx yy zz 00 F7  
  
xx = Effectslot: 00=left 01=middle 02=right     
yy = Knobs per slot enumerate: start by 02=Module0(p.1) ... 04=Module2(p.1) ... 06=Module2(p.2) etc. / 01=direct selection   
zz = Effect value in hexadecimal    
  

Module0/Knob1/page1 to value 5: 
amidi -p hw:2 -S "F0 52 00 4F 31 00 02 05 00 F7"  
Module1/Knob1/page1 to value 23:  
amidi -p hw:2 -S "F0 52 00 4F 31 01 02 17 00 F7"  
Module2/Knob1/page1 to value 42:  
amidi -p hw:2 -S "F0 52 00 4F 31 02 02 2A 00 F7"  
  
Mittlerer Knopf(1) für den linken Effekt auf den Wert 5:  
amidi -p hw:2 -S "F0 52 00 4F 31 00 03 05 00 F7"  
Mittleren Knopf(1) für den mittleren Effekt auf den Wert 23:  
amidi -p hw:2 -S "F0 52 00 4F 31 01 03 17 00 F7"  
Mittleren Knopf(1) für den rechten Effekt auf den Wert 42:  
amidi -p hw:2 -S "F0 52 00 4F 31 02 03 2A 00 F7"  
  
Rechter Knopf für den linken Effekt auf den Wert 5  
amidi -p hw:2 -S "F0 52 00 4F 31 00 04 05 00 F7"  
etc.  
x  
  
Module0/Knob1/page2 to value 5:  
amidi -p hw:2 -S "F0 52 00 4F 31 00 05 05 00 F7"  
x  
x  
Module2/Knob3/page2 to value 42:  
amidi -p hw:2 -S "F0 52 00 4F 31 02 07 2A 00 F7"  
  
Module0/Knob1/page3 to value 5:   
amidi -p hw:2 -S "F0 52 00 4F 31 00 08 05 00 F7"  
etc.  
x  



Global:  
----------------------------------------------------------
Signalweg vorwärts/rückwarts (0x = 0 oder 1):
Flip signal path forward/backward:    
F0 52 00 4F 31 03 09 0x 00 F7  


Im Total-Modus  
Level: F0 52 00 4F 31 03 02 xx 00 F7  


The 32er line:  
---------------------------------------------------------------------
Store the current preset to D9:   
amidi -p hw:2 -S "F0 52 00 4F 32 01 00 00 27 00 00 00 00 00 F7"  
  
Swap Patch from A1 to D9, store it and change to D9:  
amidi -p hw:2 -S "F0 52 00 4F 32 02 00 0 01 00 00 27 00 00 F7"  
  
  
Change patch in SysEx (G4):  
amidi -p hw:2 -S "F0 52 00 4F 32 C0 40 F7"  
  
in Control Change:  
amidi -p hw:2 -S "C0 40"  


SysEx of Death:  
--------------------------------------------------------------------- 
If you send these messages, the ZFXB3 will crash, and have to reboot. Be careful!  
amidi -p hw:2 -S "F0 52 00 4F 31 03 0C 17 00 F7"  
amidi -p hw:2 -S "f0 52 00 4f 31 03 xx yy 00 f7"  
xx from 0C up to 1A / from 1B up to 2F is okay /  from 30 to ??? it will crash again.    
yy = arbitrarily  




Appendix:  
------------------------------------------------------------------------

(1) The structure of a .b3p-file:  
----------------------------------
<?xml version="1.0" encoding="UTF-8"?>  
  
<PatchData>  
  <Product>B3</Product>  
  <Name>EQTEST</Name>	<!-- e.g. ParaEQ -->  
  <Tooltip></Tooltip>  
  <Keywords></Keywords>  
  <Version>1.20</Version>	<!-- System Version / not Preset Version -->  
  <Module0>		<!-- Effectslot left -->  
    <Prm0>0</Prm0>	<!-- on/off -->  
    <Prm1>21</Prm1>	<!-- Preset - 20=GraficEQ/21=ParaEQ/71=Splitter -->  
    <Prm2>27</Prm2>	<!-- Freq1 - 0(20Hz)/... to 27(2.5kHz) ... 29(3.6kHz) 36(16kHz)/37(20kHz) / left knob -->  
    <Prm3>1</Prm3>	<!-- Q1 - 0(0.5)/1(1)/ middle knob-->   
    <Prm4>25</Prm4>	<!-- Gain1 0(-20) ... 20(0) ... 25(+5) ... 40(+20) / right knob -->  
    <Prm5>29</Prm5>	<!-- Freq2 - 0(20Hz)/... to 27(2.5kHz) ... 29(3.6kHz) 36(16kHz)/37(20kHz) / left knob page 2 -->  
    <Prm6>0</Prm6>	<!-- Q2 - 0(0.5)/1(1)/ middle knob page 2-->  
    <Prm7>10</Prm7>	<!-- Gain2 0(-20) ... 20(0) ... 25(+5) ... 40(+20) / right knob page 2-->  
    <Prm8>150</Prm8>	<!-- Level / left knob page 3-->  
    <Prm9>0</Prm9>	<!-- / middle knob page 3-->  
    <Prm10>0</Prm10>	<!-- / right knob page 3-->  
  </Module0>  
  <Module1>		<!-- Effectslot middle / empty/standard OptComp -->   
    <Prm0>0</Prm0>  
    <Prm1>67</Prm1>  
    <Prm2>6</Prm2>  
    <Prm3>58</Prm3>  
    <Prm4>77</Prm4>  
    <Prm5>0</Prm5>  
    <Prm6>0</Prm6>  
    <Prm7>0</Prm7>  
    <Prm8>0</Prm8>  
    <Prm9>0</Prm9>  
    <Prm10>0</Prm10>  
  </Module1>  
  <Module2>		<!-- Effectslot right / empty/standard OptComp -->  
    <Prm0>0</Prm0>  
    <Prm1>67</Prm1>  
    <Prm2>6</Prm2>  
    <Prm3>58</Prm3>  
    <Prm4>77</Prm4>  
    <Prm5>0</Prm5>  
    <Prm6>0</Prm6>  
    <Prm7>0</Prm7>  
    <Prm8>0</Prm8>  
    <Prm9>0</Prm9>  
    <Prm10>0</Prm10>  
  </Module2>  
  <Module3>  
    <Prm0>100</Prm0>	<!-- Patch Level -->  
    <Prm1>0</Prm1>	<!-- Switch assign /0=no/1=FX1/2=FX2/3=FX3/4=TapTempo/5=Bypass/Mute -->  
    <Prm2>0</Prm2>	<!-- Switch addition / e.g. FX2 has two options = Prm1=2 Prm2=0 or 1 -->  
    <Prm3>0</Prm3>	<!-- Pedal assign /0=no/1=FX1/2=FX2/3=FX3/4=InputVol/5=OutputVol/6=Balance -->  
    <Prm4>0</Prm4>	<!-- Pedal min-->  
    <Prm5>0</Prm5>	<!-- Pedal max-->  
    <Prm6>0</Prm6>	<!-- ??? -->  
    <Prm7>100</Prm7>	<!-- Balance -->  
    <Prm8>0</Prm8>	<!-- ??? -->  
    <Prm9>0</Prm9>	<!-- ??? -->  
    <Prm10>0</Prm10>	<!-- ??? -->  
  </Module3>  
  <Module4>		<!-- ??? -->  		
    <Prm0>0</Prm0>  
    <Prm1>0</Prm1>  
    <Prm2>0</Prm2>  
    <Prm3>0</Prm3>  
    <Prm4>0</Prm4>  
    <Prm5>0</Prm5>  
    <Prm6>0</Prm6>  
    <Prm7>0</Prm7>  
    <Prm8>0</Prm8>  
    <Prm9>0</Prm9>  
    <Prm10>0</Prm10>  
  </Module4>  
</PatchData>  
  
  
  
  
  
  
(2) The structure of single patch representation:  
----------------------------------

The representation of a whole fx-patch and a first try how I can parse it from/to the xml-file and transmit it to the device.    

F0 52 00 4F 28 20 7F 24 40 16 50 01 32 00 00 00 00 00 00 27 2E 10 40 00 10 02 00 00 00 08 00 00 00 28 26 40 02 00 00 00 0D 4C 2A 00 00 01 32 64 60 00 00 03 00 00 0C 4E 6F 69 73 65 47 00 46 75 7A 7A 00 F7  
Unlock device:  
amidi -p hw:2 -S "F0 52 00 4F 50 F7"	  
  
  
F0 = SysEx start  
52 = Vendor ID  
00 = Device ID  
4F = Model ID  
28 = ?initiator for full message?  
20 = ?count msg for m0p2?  
7F = m0p0 / 7E=off 7F=on - different  
24  
40  
16  
50  
01  
32  
00  
00  
00  
00  
00  
00  
27 = m1p0 / 26=off 27=on / different  
2E  
10  
40  
00  
10  
02  
00  
00  
00  
08  
00  
00  
00  
28 = m2p0 / 28=off 29=on /different   
26  
40  
02  
00  
00  
00  
0D  
4C  
2A  
00  
00  
01  
32  
64 = ?64=100 in dec. Level or Bal?  
60 = ?m3p3 / CTRL PDL 1/ 02=No Assign/62=Dest1/42=Dest2/22=Dest3 / e.g. 22 02 20?     
00  
00  
03  
00  
00  
0C  
4E 6F 69 73 65 47 00 46 75 7A 7A = Patchname / echo -n "NoiseGFuzz" | od -A n -t x1 = 4e 6f 69 73 65 47 46 75 7a 7a    
00 = ?checksum?  
F7 = SysEx end   
    
  
  
 

Fußschalter mXp0  
F0 52 00 4F 28 20 7F 24 40 16 50 01 32 00 00 00 00 00 00 26 2E 10 40 00 10 02 00 00 00 08 00 00 00 28 26 40 02 00 00 00 0D 4C 2A 00 00 01 32 64 60 00 00 03 00 00 0C 4E 6F 69 73 65 47 00 46 75 7A 7A 00 F7  
F0 52 00 4F 28 20 7E 24 40 16 50 01 32 00 00 00 00 00 00 27 2E 10 40 00 10 02 00 00 00 08 00 00 00 28 26 40 02 00 00 00 0D 4C 2A 00 00 01 32 64 60 00 00 03 00 00 0C 4E 6F 69 73 65 47 00 46 75 7A 7A 00 F7  
F0 52 00 4F 28 20 7F 24 40 16 50 01 32 00 00 00 00 00 00 27 2E 10 40 00 10 02 00 00 00 08 00 00 00 28 26 40 02 00 00 00 0D 4C 2A 00 00 01 32 64 60 00 00 03 00 00 0C 4E 6F 69 73 65 47 00 46 75 7A 7A 00 F7  
  
  																	     
  

Module0: Knob left m0p2  
F0 52 00 4F 28 20 7F 22 40 16 50 01 32 00 00 00 00 00 00 27 2E 10 40 00 10 02 00 00 00 08 00 00 00 29 26 40 02 00 00 00 0D 4C 2A 00 00 05 32 64 60 00 00 0C 00 00 0C 4E 6F 69 73 65 47 00 46 75 7A 7A 00 F7  
80:  
F0 52 00 4F 28 20 7F 20 40 16 50 01 32 00 00 00 00 00 00 27 2E 10 40 00 10 02 00 00 00 08 00 00 00 29 26 40 02 00 00 00 0D 4C 2A 00 00 05 32 64 60 00 00 0C 00 00 0C 4E 6F 69 73 65 47 00 46 75 7A 7A 00 F7  
79:  
F0 52 00 4F 28 20 7F 1E 40 16 50 01 32 00 00 00 00 00 00 27 2E 10 40 00 10 02 00 00 00 08 00 00 00 29 26 40 02 00 00 00 0D 4C 2A 00 00 05 32 64 60 00 00 0C 00 00 0C 4E 6F 69 73 65 47 00 46 75 7A 7A 00 F7   
0:  
F0 52 00 4F 28 00 7F 00 40 16 50 01 32 00 00 00 00 00 00 27 2E 10 40 00 10 02 00 00 00 08 00 00 00 29 26 40 02 00 00 00 0D 4C 2A 00 00 05 32 64 60 00 00 0C 00 00 0C 4E 6F 69 73 65 47 00 46 75 7A 7A 00 F7  
16:  
F0 52 00 4F 28 00 7F 20 40 16 50 01 32 00 00 00 00 00 00 27 2E 10 40 00 10 02 00 00 00 08 00 00 00 29 26 40 02 00 00 00 0D 4C 2A 00 00 05 32 64 60 00 00 0C 00 00 0C 4E 6F 69 73 65 47 00 46 75 7A 7A 00 F7  
1:  
F0 52 00 4F 28 00 7F 02 40 16 50 01 32 00 00 00 00 00 00 27 2E 10 40 00 10 02 00 00 00 08 00 00 00 29 26 40 02 00 00 00 0D 4C 2A 00 00 05 32 64 60 00 00 0C 00 00 0C 4E 6F 69 73 65 47 00 46 75 7A 7A 00 F7  
  
  
  
  



The associated XML-file looks like that:  
  
<?xml version="1.0" encoding="UTF-8"?>  
  
<PatchData>  
   <Product>B3</Product>  
   <Name>NoiseGFuzz</Name>  
   <Tooltip></Tooltip>  
   <Keywords></Keywords>  
   <Version>1.20</Version>  
   <Module0>  
     <Prm0>1</Prm0>  
      <Prm1>63</Prm1>  
    <Prm2>82</Prm2>  
    <Prm3>89</Prm3>  
    <Prm4>42</Prm4>  
    <Prm5>50</Prm5>  
    <Prm6>0</Prm6>  
    <Prm7>0</Prm7>  
    <Prm8>0</Prm8>  
    <Prm9>0</Prm9>  
    <Prm10>0</Prm10>  
  </Module0>  
  <Module1>  
    <Prm0>1</Prm0>  
    <Prm1>19</Prm1>  
    <Prm2>23</Prm2>  
    <Prm3>1</Prm3>  
    <Prm4>82</Prm4>  
    <Prm5>0</Prm5>  
    <Prm6>0</Prm6>   
    <Prm7>0</Prm7>  
    <Prm8>0</Prm8>  
    <Prm9>0</Prm9>  
    <Prm10>0</Prm10>  
  </Module1>  
  <Module2>   
    <Prm0>1</Prm0>  
    <Prm1>84</Prm1>   
    <Prm2>19</Prm2>  
    <Prm3>9</Prm3>  
    <Prm4>0</Prm4>  
    <Prm5>13</Prm5>  
    <Prm6>76</Prm6>  
    <Prm7>42</Prm7>  
    <Prm8>0</Prm8> 
    <Prm9>0</Prm9>  
    <Prm10>50</Prm10>  
  </Module2>  
  <Module3>  
    <Prm0>100</Prm0>  
    <Prm1>0</Prm1>  
    <Prm2>0</Prm2>  
    <Prm3>2</Prm3>  
    <Prm4>0</Prm4>  
    <Prm5>24</Prm5>  
    <Prm6>0</Prm6>  
    <Prm7>100</Prm7>  
    <Prm8>0</Prm8>  
    <Prm9>0</Prm9>  
    <Prm10>0</Prm10>  
  </Module3>  
  <Module4>  
    <Prm0>0</Prm0>  
    <Prm1>0</Prm1>  
    <Prm2>0</Prm2>  
    <Prm3>0</Prm3>  
    <Prm4>0</Prm4>  
    <Prm5>0</Prm5>  
    <Prm6>0</Prm6>  
    <Prm7>0</Prm7>  
    <Prm8>0</Prm8>  
    <Prm9>0</Prm9>  
    <Prm10>0</Prm10>  
  </Module4>  
</PatchData>  
  
  


