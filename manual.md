
Explanation:  
Preset = The effect itself, integrated in the firmware.  
Patch = The whole configuration of one effect chain you edited.  
Bank = The whole storage of max. 100 patches. (0-99/A0-J9)  

FYI: hw:2 by amidi can directed to other ports in other setups.  

Not complete yet... to be continued...  


Lock and requests:  
-----------------------------------------------
Unlock device:  
amidi -p hw:2 -S "F0 52 00 4F 50 F7"  

Lock device again:  
amidi -p hw:2 -S "F0 52 00 4F 51 F7"  
If the device is locked, the patch will be reset. Does not work for adjustments inside the totalmodus.  

Request position in bank:  
amidi -p hw:2 -S "F0 52 00 4F 33 F7"  

Request the patch configuration:  
amidi -p hw:2 -S "F0 52 00 4F 29 F7"  


Change the preset:  
-----------------------------------------------
as Control Change Messages:  
A0 = amidi -p hw:2 -S "C0 00"  
A1 = amidi -p hw:2 -S "C0 01"  
A2 = amidi -p hw:2 -S "C0 02"  
A9 = amidi -p hw:2 -S "C0 09"  
B0 = amidi -p hw:2 -S "C0 0A"  
B1 = amidi -p hw:2 -S "C0 0B"  
D1 = amidi -p hw:2 -S "C0 1F"  
... and so on in hexadecimal up to  
J9 = amidi -p hw:2 -S "C0 63"  

or as SysEx Message:  
amidi -p hw:2 -S "F0 52 00 4F 32 C0 xx F7"  


Stompbar:  
------------------------------------------------- 
Turning-off left effect (Module0):
amidi -p hw:2 -S "f0 52 00 4f 31 00 00 00 00 f7"  
turning-on ...:            
amidi -p hw:2 -S "f0 52 00 4f 31 00 00 01 00 f7"  


Turning-off middle effect (Module1):  
amidi -p hw:2 -S "f0 52 00 4f 31 01 00 00 00 f7"  
turning-on ...:            
amidi -p hw:2 -S "f0 52 00 4f 31 01 00 01 00 f7"  

Turning-off right effect (Module2):  
amidi -p hw:2 -S "f0 52 00 4f 31 02 00 00 00 f7"
turning-on ...:            
amidi -p hw:2 -S "f0 52 00 4f 31 02 00 01 00 f7"  



Change Preset directly:
--------------------------------------------------
(09 = Bit Crush)  
Left (Module0):  
amidi -p hw:2 -S "f0 52 00 4f 31 00 01 09 00 f7"  

Middle (Module1):  
amidi -p hw:2 -S "f0 52 00 4f 31 01 01 09 00 f7"  

Right (Module2):  
amidi -p hw:2 -S "f0 52 00 4f 31 02 01 09 00 f7"  


Sort it like in the firmware!:  
D Comp:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "f0 52 00 4f 31 02 01 10 00 f7" 
M Comp:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "f0 52 00 4f 31 02 01 11 00 f7"  
DualComp:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "f0 52 00 4f 31 02 01 44 00 f7"  
Slow Attck:&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "f0 52 00 4f 31 02 01 12 00 f7"  
ZNR:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "f0 52 00 4f 31 02 01 13 00 f7"  
GraphicEQ:&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "f0 52 00 4f 31 02 01 14 00 f7"  
ParaEQ:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "f0 52 00 4f 31 02 01 15 00 f7"  
Splitter:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "f0 52 00 4f 31 02 01 47 00 f7"  
BottomB:  
Exciter:  
CombFLTR:&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "f0 52 00 4f 31 02 01 16 00 f7"  
AutoWah:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amidi -p hw:2 -S "f0 52 00 4f 31 02 01 17 00 f7"  
Z-Tron:		amidi -p hw:2 -S "f0 52 00 4f 31 02 01 18 00 f7"  
M-Filter:  
A-Filter:  
Step:		amidi -p hw:2 -S "f0 52 00 4f 31 02 01 19 00 f7"  
  
StereoCho:	amidi -p hw:2 -S "f0 52 00 4f 31 02 01 20 00 f7"  
  
  
Bit Crush: 	amidi -p hw:2 -S "f0 52 00 4f 31 02 01 09 00 f7"  
Bomber:		amidi -p hw:2 -S "f0 52 00 4f 31 02 01 0a 00 f7"  
  
M-Filter:	amidi -p hw:2 -S "f0 52 00 4f 31 02 01 01 00 f7"  
  
StdSyn:		amidi -p hw:2 -S "f0 52 00 4f 31 02 01 63 00 f7"  
Z-Syn:		amidi -p hw:2 -S "f0 52 00 4f 31 02 01 67 00 f7"  
Z-Organ:	amidi -p hw:2 -S "f0 52 00 4f 31 02 01 03 00 f7"  
Defret:		amidi -p hw:2 -S "f0 52 00 4f 31 02 01 68 00 f7"  
  
FilterDIY:	amidi -p hw:2 -S "f0 52 00 4f 31 02 01 06 00 f7"  
PitchDelay:	amidi -p hw:2 -S "f0 52 00 4f 31 02 01 07 00 f7"  
StereoDelay:	amidi -p hw:2 -S "f0 52 00 4f 31 02 01 08 00 f7"  	
PhaseDIY	amidi -p hw:2 -S "f0 52 00 4f 31 02 01 05 00 f7"  
Hall:		amidi -p hw:2 -S "f0 52 00 4f 31 02 01 31 00 f7"  
Room:		amidi -p hw:2 -S "f0 52 00 4f 31 02 01 32 00 f7"  
TiledRM:	amidi -p hw:2 -S "f0 52 00 4f 31 02 01 33 00 f7"  
Spring:		amidi -p hw:2 -S "f0 52 00 4f 31 02 01 34 00 f7"  
Arena Reverb:   amidi -p hw:2 -S "f0 52 00 4f 31 02 01 35 00 f7"   
EarlyReflection	amidi -p hw:2 -S "f0 52 00 4f 31 02 01 36 00 f7"  
Air:		amidi -p hw:2 -S "f0 52 00 4f 31 02 01 37 00 f7"  
  
PedalWah:	amidi -p hw:2 -S "f0 52 00 4f 31 02 01 69 00 f7"  
  
Slicer:		amidi -p hw:2 -S "f0 52 00 4f 31 02 01 04 00 f7"  
The Vibe:	amidi -p hw:2 -S "f0 52 00 4f 31 02 01 02 00 f7"  


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
    F0 52 00 4F 31 04 xx yz 00 F7
xx = Ten digits / 0-9  
yz = Charaters   

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
F0 52 00 4f 31 00 02 05 00 F7  
F0 52 00 4f 31 02 07 2A 00 F7  
F0 52 00 4f 31 xx yy zz 00 F7  
  
xx = Effektslot: 00=links 01=mitte 02=rechts   
yy = Knöpfe pro Slot durchgezählt: angefangen bei 02=links(Seite 1) ... 04=rechts(1) ... 06=mitte(2) etc. / 01=Effektdirektanwahl (siehe oben)  
zz = Effektwert in Hexadezimal  
  
Linker Knopf(page 1) für den linken Effekt auf den Wert 5:  
amidi -p hw:2 -S "F0 52 00 4f 31 00 02 05 00 F7"  
Linke Knopf(1) für den mittleren Effekt auf den Wert 23:  
amidi -p hw:2 -S "F0 52 00 4f 31 01 02 17 00 F7"  
Linke Knopf(1) für den rechten Effekt auf den Wert 42:  
amidi -p hw:2 -S "F0 52 00 4f 31 02 02 2A 00 F7"  
  
Mittlerer Knopf(1) für den linken Effekt auf den Wert 5:  
amidi -p hw:2 -S "F0 52 00 4f 31 00 03 05 00 F7"  
Mittleren Knopf(1) für den mittleren Effekt auf den Wert 23:  
amidi -p hw:2 -S "F0 52 00 4f 31 01 03 17 00 F7"  
Mittleren Knopf(1) für den rechten Effekt auf den Wert 42:  
amidi -p hw:2 -S "F0 52 00 4f 31 02 03 2A 00 F7"  
  
Rechter Knopf für den linken Effekt auf den Wert 5  
amidi -p hw:2 -S "F0 52 00 4f 31 00 04 05 00 F7"  
etc.  
x  

Linker Knopf(page 2) für den linken Effekt auf den Wert 5:  
amidi -p hw:2 -S "F0 52 00 4f 31 00 05 05 00 F7"  
x  
x  
Rechter Knopf(page 2) für den rechten Effekt auf den Wert 42:   
amidi -p hw:2 -S "F0 52 00 4f 31 02 07 2A 00 F7"  
  
Linker Knopf(page 3) für den linken Effekt auf den Wert 5:  
amidi -p hw:2 -S "F0 52 00 4f 31 00 08 05 00 F7"  
etc.  
x  



Global:  
----------------------------------------------------------
Signalweg vorwärts/rückwarts (0x = 0 oder 1):
Flip signal path forward/backward:    
F0 52 00 4F 31 03 09 0x 00 F7  

Die restlichen Knöpfe im Globalmodus sind nicht über Midi steuerbar. Also liefern zumindest kein Signal. Rhytmus geht leider auch nicht. Dann würde noch Tuner und Looper fehlen, das wäre schon cool - vielleicht geht da was.  

Im Total-Modus  
Level: F0 52 00 4F 31 03 02 xx 00 F7  


The 32er line:  
---------------------------------------------------------------------
Store the current preset to D9:   
amidi -p hw:2 -S "F0 52 00 4F 32 01 00 00 27 00 00 00 00 00 F7"  
  
Swap Patch from A1 to G9, store it and change to D9:  
amidi -p hw:2 -S "F0 52 00 4F 32 02 00 0 01 00 00 27 00 00 F7"  
  
  
Change patch in SysEx (G4):  
amidi -p hw:2 -S "F0 52 00 4F 32 C0 40 F7"  
  
in Control Change:  
amidi -p hw:2 -S "C0 40"  


SysEx of Death:  
--------------------------------------------------------------------- 
If you send these messages, the ZFXB3 will crash, and have to reboot. Be careful!  
amidi -p hw:2 -S "F0 52 00 4F 31 03 0c 17 00 F7"  
amidi -p hw:2 -S "f0 52 00 4f 31 03 xx yy 00 f7"  
xx von 0C bis 1A / ab 1B stürzt es nicht mehr ab. Dann wieder ab 30 bis ???.  
yy = beliebig  









