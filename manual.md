  
  
Not complete yet... to be continued...  
  
  

# Preliminary information  
  
  
What is a ...? 

| Buzzword | Description | 
| --- | --- | 
| Module | The three (+n on other devices) effect slots, left, middle, right.   |
| Preset | The effect itself, integrated in the firmware.                       |  
| Patch  | The whole configuration of the three (+n) presets. One signal chain. |  
| Bank   | The whole storage of max. 100 patches. (A0-J9) (0-99)                |  
  
  
FYI: amidi -hw:2,0,0 can directed to other ports in other setups.  
All examples obtain to a B3 and tested on Arch Linux mainly with bash, dash, mksh, mrsh, yash, zsh.  
  
  
Upper case SysEx messages = transmit to device  
Lower case SysEx messages = receive from device  
  
  
  
   
  
  
## Structure of a System Exclusive (SysEx) message:  
  

    F0 52 00 4F 31 01 00 00 00 F7

| Preset | Command | 
| --- | --- |  
| F0 | SysEx Startbyte |  
| 52 | Manufacturer identifier, in this case Zoom® |  
| 00 | Device ID |  
| 4F | Model identifier, in this case B3 |  
| .. | the proper message |    
| F7 | SysEx Endbyte |   
  
  
  
## Factory reset:  
  
Press STORE/SWAP and start the device.  
  
  

# Dialogs with the device  
  
  
  
## (Un)Lock and requests:  

  
### General request to identify devices (Who are you?):  

    amidi -p hw:2,0,0 -S "F0 7E 00 06 01 F7"  
  
    f0 7e 00 06 02 52 4f 00  00 00 31 2e 32 30 f7   
    06 = General Information    
    02 = Identity Reply     
    52 = Manufacturer ID  
    4f = Model ID  
    31 2e 32 30 = 1.20 = Version     
  
    
### Unlock device:  
The device is locked for SysEx messages by default. It accept only control change and general messages. Open Sesame!  
  
    amidi -p hw:2,0,0 -S "F0 52 00 4F 50 F7"   
...no answer.  
  
    
    
### Lock device again:  

    amidi -p hw:2,0,0 -S "F0 52 00 4F 51 F7"  
If the device is locked, the patch will be reset. Does not work for adjustments for the totalmodus.  
...no answer.  
  
  
### Request current location in bank:  

    amidi -p hw:2,0,0 -S "F0 52 00 4F 33 F7"  

    B0 00 00 <- ?CC: Bank MSB -Most Significant Byte?  
    B0 20 00 <- ?CC: Bank LSB -Least Significant Byte?      
    C0 2B  <- Bank E3    
  
  
### Request the current patch configuration:  

    amidi -p hw:2,0,0 -S "F0 52 00 4F 29 F7"  
... (68 byte) see appendix (2) for further information.  
    

### Request patches configuration inclusive location info (xx=CC) silently:  
  
    amidi -p hw:2,0,0 -S "F0 52 00 4F 09 00 00 xx F7"  
... (78 byte) see appendix (x) for further information.


### Request global, tuner, looper, ??? configuration:    

    amidi -p hw:2,0,0 -S "F0 52 00 4F 2B F7"  
... see appendix (3) for further information.  


  
  
  
### other answers:  

    f0 52 00 4f 00 00 f7 = confirm / okay   
    f0 52 00 4f 20 00 f7 = ??? refused ???  
    f0 52 00 4f 00 0a f7 = ???   
    f0 52 00 4f 00 0b f7 = ???  
    f0 52 00 4f 32 01 00 00 40 00 00 00 00 00 f7 = confirm saving patch to current position (G4(=40))  

  
amidi -p hw:2,0,0 -S "F0 52 00 4F 01 F7"  
f0 52 00 4f 00 0b f7  
   
amidi -p hw:2,0,0 -S "F0 52 00 4F 04 F7" (and 05)  
f0 52 00 4f 00 00 f7  
  
amidi -p hw:2,0,0 -S "F0 52 00 4F 07 F7"  
f0 52 00 4f 06 64 00 36 00 f7
  
amidi -p hw:2,0,0 -S "F0 52 00 4F 0E F7"  
f0 52 00 4f 00 0b f7  
  
amidi -p hw:2,0,0 -S "F0 52 00 4F 16 F7"  
f0 52 00 4f 17 45 00 00 00 00 f7  
  
amidi -p hw:2,0,0 -S "F0 52 00 4F 09 00 00 00 F7"
f0 52 00 4f 08 00 00 00 36 00 50 19 1a 00 02 48 00 41 00 00 00 00 00 00 28 10 00 40 02 60 00 0c 0e 0c 08 0a 64 00 3f 22 40 04 00 50 00 0e 32 50 01 00 35 3c 64 02 00 00 0c 00 00 0c 4d 61 72 6b 42 6f 00 6f 73 74 20 00 16 3d 5b 25 09 f7  
amidi -p hw:2,0,0 -S "F0 52 00 4F 08 00 00 00 36 00 50 19 1A 00 02 48 00 41 00 00 00 00 00 00 28 10 00 40 02 60 00 0C 0E 0C 08 0A 64 00 3F 22 40 04 00 50 00 0E 32 50 01 00 35 3C 64 02 00 00 0C 00 00 0C 4D 61 72 6B 42 6F 00 6F 73 74 20 00 16 3D 5B 25 09 F7"  
f0 52 00 4f 00 00 f7  
Compare it with other current patch / 29    
  
  
  
 
  
## Change the preset:  
  
... as Control Change Messages:  

| Bank | CC | Command | 
| --- | --- | --- |
| A0 | 00 | amidi -p hw:2,0,0 -S "C0 00" |  
| A1 | 01 | amidi -p hw:2,0,0 -S "C0 01" | 
| A2 | 02 | amidi -p hw:2,0,0 -S "C0 02" |
| A3 | 03 | amidi -p hw:2,0,0 -S "C0 03" |
| A4 | 04 | amidi -p hw:2,0,0 -S "C0 04" |
| A5 | 05 | amidi -p hw:2,0,0 -S "C0 05" |
| A6 | 06 | amidi -p hw:2,0,0 -S "C0 06" |
| A7 | 07 | amidi -p hw:2,0,0 -S "C0 07" |
| A8 | 08 | amidi -p hw:2,0,0 -S "C0 08" |
| A9 | 09 | amidi -p hw:2,0,0 -S "C0 09" | 
| B0 | 0A | amidi -p hw:2,0,0 -S "C0 0A" | 
| B1 | 0B | amidi -p hw:2,0,0 -S "C0 0B" |
| B2 | 0C | amidi -p hw:2,0,0 -S "C0 0C" |
| B3 | 0D | amidi -p hw:2,0,0 -S "C0 0D" |
| B4 | 0E | amidi -p hw:2,0,0 -S "C0 0E" |
| B5 | 0F | amidi -p hw:2,0,0 -S "C0 0F" |
| B6 | 10 | amidi -p hw:2,0,0 -S "C0 10" |
| B7 | 11 | amidi -p hw:2,0,0 -S "C0 11" |
| B8 | 12 | amidi -p hw:2,0,0 -S "C0 12" |
| B9 | 13 | amidi -p hw:2,0,0 -S "C0 13" |
| C0 | 14 | amidi -p hw:2,0,0 -S "C0 14" |
| C1 | 15 | amidi -p hw:2,0,0 -S "C0 15" |
| C2 | 16 | amidi -p hw:2,0,0 -S "C0 16" |
| C3 | 17 | amidi -p hw:2,0,0 -S "C0 17" |
| C4 | 18 | amidi -p hw:2,0,0 -S "C0 18" |
| C5 | 19 | amidi -p hw:2,0,0 -S "C0 19" |
| C6 | 1A | amidi -p hw:2,0,0 -S "C0 1A" |
| C7 | 1B | amidi -p hw:2,0,0 -S "C0 1B" |
| C8 | 1C | amidi -p hw:2,0,0 -S "C0 1C" |
| C9 | 1D | amidi -p hw:2,0,0 -S "C0 1D" |
| D0 | 1E | amidi -p hw:2,0,0 -S "C0 1E" |
| D1 | 1F | amidi -p hw:2,0,0 -S "C0 1F" |
| D2 | 20 | amidi -p hw:2,0,0 -S "C0 20" |
| D3 | 21 | amidi -p hw:2,0,0 -S "C0 21" |
| D4 | 22 | amidi -p hw:2,0,0 -S "C0 22" |
| D5 | 23 | amidi -p hw:2,0,0 -S "C0 23" |
| D6 | 24 | amidi -p hw:2,0,0 -S "C0 24" |
| D7 | 25 | amidi -p hw:2,0,0 -S "C0 25" |
| D8 | 26 | amidi -p hw:2,0,0 -S "C0 26" |
| D9 | 27 | amidi -p hw:2,0,0 -S "C0 27" |
| E0 | 28 | amidi -p hw:2,0,0 -S "C0 28" |
| E1 | 29 | amidi -p hw:2,0,0 -S "C0 29" |
| E2 | 2A | amidi -p hw:2,0,0 -S "C0 2A" |
| E3 | 2B | amidi -p hw:2,0,0 -S "C0 2B" |
| E4 | 2C | amidi -p hw:2,0,0 -S "C0 2C" |
| E5 | 2D | amidi -p hw:2,0,0 -S "C0 2D" |
| E6 | 2E | amidi -p hw:2,0,0 -S "C0 2E" |
| E7 | 2F | amidi -p hw:2,0,0 -S "C0 2F" |
| E8 | 30 | amidi -p hw:2,0,0 -S "C0 30" |
| E9 | 31 | amidi -p hw:2,0,0 -S "C0 31" |
| F0 | 32 | amidi -p hw:2,0,0 -S "C0 32" |
| F1 | 33 | amidi -p hw:2,0,0 -S "C0 33" |
| F2 | 34 | amidi -p hw:2,0,0 -S "C0 34" |
| F3 | 35 | amidi -p hw:2,0,0 -S "C0 35" |
| F4 | 36 | amidi -p hw:2,0,0 -S "C0 36" |
| F5 | 37 | amidi -p hw:2,0,0 -S "C0 37" |
| F6 | 38 | amidi -p hw:2,0,0 -S "C0 38" |
| F7 | 39 | amidi -p hw:2,0,0 -S "C0 39" |
| F8 | 3A | amidi -p hw:2,0,0 -S "C0 3A" |
| F9 | 3B | amidi -p hw:2,0,0 -S "C0 3B" |
| G0 | 3C | amidi -p hw:2,0,0 -S "C0 3C" |
| G1 | 3D | amidi -p hw:2,0,0 -S "C0 3D" |
| G2 | 3E | amidi -p hw:2,0,0 -S "C0 3E" |
| G3 | 3F | amidi -p hw:2,0,0 -S "C0 3F" |
| G4 | 40 | amidi -p hw:2,0,0 -S "C0 40" |
| G5 | 41 | amidi -p hw:2,0,0 -S "C0 41" |
| G6 | 42 | amidi -p hw:2,0,0 -S "C0 42" |
| G7 | 43 | amidi -p hw:2,0,0 -S "C0 43" |
| G8 | 44 | amidi -p hw:2,0,0 -S "C0 44" |
| G9 | 45 | amidi -p hw:2,0,0 -S "C0 45" |
| H0 | 46 | amidi -p hw:2,0,0 -S "C0 46" |
| H1 | 47 | amidi -p hw:2,0,0 -S "C0 47" |
| H2 | 48 | amidi -p hw:2,0,0 -S "C0 48" |
| H3 | 49 | amidi -p hw:2,0,0 -S "C0 49" |
| H4 | 4A | amidi -p hw:2,0,0 -S "C0 4A" |
| H5 | 4B | amidi -p hw:2,0,0 -S "C0 4B" |
| H6 | 4C | amidi -p hw:2,0,0 -S "C0 4C" |
| H7 | 4D | amidi -p hw:2,0,0 -S "C0 4D" |
| H8 | 4E | amidi -p hw:2,0,0 -S "C0 4E" |
| H9 | 4F | amidi -p hw:2,0,0 -S "C0 4F" |
| I0 | 50 | amidi -p hw:2,0,0 -S "C0 50" |
| I1 | 51 | amidi -p hw:2,0,0 -S "C0 51" |
| I2 | 52 | amidi -p hw:2,0,0 -S "C0 52" |
| I3 | 53 | amidi -p hw:2,0,0 -S "C0 53" |
| I4 | 54 | amidi -p hw:2,0,0 -S "C0 54" |
| I5 | 55 | amidi -p hw:2,0,0 -S "C0 55" |
| I6 | 56 | amidi -p hw:2,0,0 -S "C0 56" |
| I7 | 57 | amidi -p hw:2,0,0 -S "C0 57" |
| I8 | 58 | amidi -p hw:2,0,0 -S "C0 58" |
| I9 | 59 | amidi -p hw:2,0,0 -S "C0 59" |
| I0 | 50 | amidi -p hw:2,0,0 -S "C0 50" |
| J0 | 5A | amidi -p hw:2,0,0 -S "C0 5A" |
| J1 | 5B | amidi -p hw:2,0,0 -S "C0 5B" |
| J2 | 5C | amidi -p hw:2,0,0 -S "C0 5C" |
| J3 | 5D | amidi -p hw:2,0,0 -S "C0 5D" |
| J4 | 5E | amidi -p hw:2,0,0 -S "C0 5E" |
| J5 | 5F | amidi -p hw:2,0,0 -S "C0 5F" |
| J6 | 60 | amidi -p hw:2,0,0 -S "C0 60" |
| J7 | 61 | amidi -p hw:2,0,0 -S "C0 61" |
| J8 | 62 | amidi -p hw:2,0,0 -S "C0 62" |
| J9 | 63 | amidi -p hw:2,0,0 -S "C0 63" |
  
... or as SysEx Message:  
amidi -p hw:2,0,0 -S "F0 52 00 4F Cn xx F7"  


## Stompbar:  

Turn off left effect (Module0):  
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 00 00 00 00 F7"  
turn on ...:            
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 00 00 01 00 F7"  
  
Turn off middle effect (Module1):  
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 01 00 00 00 F7"  
turn on ...:            
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 01 00 01 00 F7"  
  
Turn off right effect (Module2):  
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 00 00 00 F7"  
turn on ...:            
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 00 01 00 F7"  
  
  
## Change Preset directly:
  
    (09 = Bit Crush)  
    Left (Module0):  
    amidi -p hw:2,0,0 -S "F0 52 00 4F 31 00 01 09 00 F7"  
  
    Middle (Module1):  
    amidi -p hw:2,0,0 -S "F0 52 00 4F 31 01 01 09 00 F7"  
  
    Right (Module2):  
    amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 09 00 F7"  
  
Sort it like in the firmware!      
   
| Preset | Command | 
| --- | --- |    
| OptComp         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 43 00 F7" |   
| D Comp          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 10 00 F7" |  
| M Comp          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 11 00 F7" |
| DualComp        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 44 00 F7" |  
| 160Comp         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 45 00 F7" |  
| Limiter         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 46 00 F7" |  
| Slow Attck      |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 12 00 F7" |  
| ZNR             |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 13 00 F7" |  
| GraphicEQ       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 14 00 F7" |  
| ParaEQ          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 15 00 F7" |  
| Splitter        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 47 00 F7" |  
| BottomB         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 48 00 F7" |    
| Exciter         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 49 00 F7" |    
| CombFLTR        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 16 00 F7" |  
| AutoWah         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 17 00 F7" |  
| Z-Tron          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 18 00 F7" |  
| M-Filter        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 01 00 F7" |  
| A-Filter        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 4A 00 F7" |   
| Cry             |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 1A 00 F7" |  
| Step            |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 19 00 F7" |  
| SeqFilter       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 0C 00 F7" |    
| RandomFilter    |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 0D 00 F7" |    
| Booster         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 4C 00 F7" |    
| Overdrive       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 4B 00 F7" |    
| BassMuff        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 4E 00 F7" |                                                 |
| TScream         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 3B 00 F7" |    
| Dist1           |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 3C 00 F7" |     
| Squeak          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 3D 00 F7" |    
| FuzzSmile       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 3E 00 F7" |     
| GreatMuff       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 3F 00 F7" |    
| MetalWRLD       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 40 00 F7" |    
| BassDrive       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 4F 00 F7" |    
| D.I+            |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 50 00 F7" |    
| BassBB          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 4d 00 F7" |     
| DI5             |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 51 00 F7" |    
| BassPre         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 52 00 F7" |  
| AcBsPre         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 53 00 F7" |    
| SVT             |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 54 00 F7" |    
| B-Man           |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 55 00 F7" |    
| Hrt-3500        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 56 00 F7" |    
| SMR             |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 57 00 F7" |    
| FlipTop         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 58 00 F7" |    
| Acoustic        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 59 00 F7" |    
| Agamp           |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 5A 00 F7" |    
| Monotone        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 5B 00 F7" |   
| Super B         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 5C 00 F7" |    
| G-Krueger       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 5D 00 F7" |  
| Heaven          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 5E 00 F7" |  
| MarkB           |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 5F 00 F7" |    
| Tremolo         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 1C 00 F7" |    
| Slicer          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 04 00 F7" |  
| 4-Phaser        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 60 00 F7" |    
| 8-Phaser        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 61 00 F7" |    
| The Vibe        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 02 00 F7" |  
| Duo-Phase       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 0B 00 F7" |    
| WarpPhaser      |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 0E 00 F7" |    
| Chorus          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 1E 00 F7" |     
| Detune          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 1F 00 F7" |    
| VintageCE       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 20 00 F7" |    
| StereoCho       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 21 00 F7" |  
| Ensemble        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 22 00 F7" |    
| VinFLNGR        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 23 00 F7" |    
| Flanger         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 42 00 F7" |    
| DynaFLNGR       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 24 00 F7" |    
| Vibrato         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 25 00 F7" |   
| Octave          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 1B 00 F7" |    
| PitchSHFT       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 26 00 F7" |    
| MonoPitch       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 28 00 F7" |    
| HPS             |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 29 00 F7" |    
| BendCho         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 27 00 F7" |    
| RingMod         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 1D 00 F7" |       
| Bit Crush       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 09 00 F7" |  
| Bomber          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 0A 00 F7" |  
| MonoSyn         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 62 00 F7" |    
| StdSyn          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 63 00 F7" |  
| SynTlk          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 64 00 F7" |    
| V-Syn           |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 65 00 F7" |    
| 4ChoiceSyn      |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 66 00 F7" |   
| Z-Syn           |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 67 00 F7" |  
| Z-Organ         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 03 00 F7" |  
| Defret          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 68 00 F7" |  
| Delay           |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 2A 00 F7" |    
| TapeEcho        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 2B 00 F7" |    
| ModDealay       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 2C 00 F7" |    
| AnalogDLY       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 2D 00 F7" |    
| ReverseDelay    |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 2E 00 F7" |    
| MultiTapDelay   |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 2F 00 F7" |  
| Dyna Delay      |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 30 00 F7" |    
| FilterDIY       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 06 00 F7" |   
| PitchDelay      |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 07 00 F7" |  
| StereoDelay     |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 08 00 F7" |  	
| PhaseDIY        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 05 00 F7" |  
| TriggerHoldDly  |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 0F 00 F7" |    
| HD Reverb       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 41 00 F7" |    
| Hall            |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 31 00 F7" |  
| Room            |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 32 00 F7" |  
| TiledRM         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 33 00 F7" |  
| Spring          |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 34 00 F7" |  
| Arena Reverb    |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 35 00 F7" |   
| EarlyReflection |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 36 00 F7" |  
| Air             |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 37 00 F7" |  
| CompDist        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 6B 00 F7" |  
| OctDist         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 6C 00 F7" |    
| AWahDist        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 6D 00 F7" |    
| CompAWah        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 6E 00 F7" |   
| PH+Dist         |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 6F 00 F7" |       
| PedalVox        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 38 00 F7" |
| PedalWah        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 69 00 F7" |  
| PDL Reso        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 6A 00 F7" |  
| PDL Pitch       |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 39 00 F7" |  
| PdlMnPit        |amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 01 3A 00 F7" |    
    
  
  
  
## Change Tempo:  
  
x changes the value by 16 bpm, y by 1 bpm. If the value rise above 127, it counts z to 1 and xy change to zero.  
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 03 08 xy 0z F7"  
  
| BPM | Command | 
| --- | --- |   
| 40  | amidi -p hw:2,0,0 -S "F0 52 00 4F 31 03 08 00 00 F7" |  
| 40  | amidi -p hw:2,0,0 -S "F0 52 00 4F 31 03 08 28 00 F7" |  
| 100 | amidi -p hw:2,0,0 -S "F0 52 00 4F 31 03 08 64 00 F7" |  
| 120 | amidi -p hw:2,0,0 -S "F0 52 00 4F 31 03 08 78 00 F7" |  
| 127 | amidi -p hw:2,0,0 -S "F0 52 00 4F 31 03 08 7F 00 F7" |  
| 128 | amidi -p hw:2,0,0 -S "F0 52 00 4F 31 03 08 00 01 F7" |  
| 129 | amidi -p hw:2,0,0 -S "F0 52 00 4F 31 03 08 01 01 F7" |  
| 152 | amidi -p hw:2,0,0 -S "F0 52 00 4F 31 03 08 18 01 F7" |    
| 153 | amidi -p hw:2,0,0 -S "F0 52 00 4F 31 03 08 19 01 F7" |  
| 168 | amidi -p hw:2,0,0 -S "F0 52 00 4F 31 03 08 28 01 F7" |  
| 249 | amidi -p hw:2,0,0 -S "F0 52 00 4F 31 03 08 79 01 F7" |  
| 250 | amidi -p hw:2,0,0 -S "F0 52 00 4F 31 03 08 7A 01 F7" |   
  
  
  
## Names:  
  
    F0 52 00 4F 31 04 xx yz 00 F7  
xx = Ten digits / 00-09  
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

| Caracter | Command | 
| --- | --- |   
| Space  | F0 52 00 4F 31 04 00 20 00 F7 | 
| !      | F0 52 00 4F 31 04 00 21 00 F7 |  
| \#     | F0 52 00 4F 31 04 00 23 00 F7 |  
| $      | F0 52 00 4F 31 04 00 24 00 F7 |  
| %      | F0 52 00 4F 31 04 00 25 00 F7 |  
| &      | F0 52 00 4F 31 04 00 26 00 F7 |  
| '      | F0 52 00 4F 31 04 00 27 00 F7 |  
| (      | F0 52 00 4F 31 04 00 28 00 F7 |  
| )      | F0 52 00 4F 31 04 00 29 00 F7 |  
| \+     | F0 52 00 4F 31 04 00 2B 00 F7 |  
| ,      | F0 52 00 4F 31 04 00 2C 00 F7 |  
| \-     | F0 52 00 4F 31 04 00 2D 00 F7 |  
| .      | F0 52 00 4F 31 04 00 2E 00 F7 |  
| ;      | F0 52 00 4F 31 04 00 3B 00 F7 |  
| =      | F0 52 00 4F 31 04 00 3D 00 F7 |  
| @      | F0 52 00 4F 31 04 00 40 00 F7 |  
| [      | F0 52 00 4F 31 04 00 5B 00 F7 |  
| ]      | F0 52 00 4F 31 04 00 5D 00 F7 |  
| ^      | F0 52 00 4F 31 04 00 5E 00 F7 |  
| _      | F0 52 00 4F 31 04 00 5F 00 F7 |  
| `      | F0 52 00 4F 31 04 00 60 00 F7 |  
| {      | F0 52 00 4F 31 04 00 7B 00 F7 |  
| }      | F0 52 00 4F 31 04 00 7D 00 F7 |  
| ~      | F0 52 00 4F 31 04 00 7E 00 F7 |  
  
  
  
Revise and translate below this!!!  
-----------------------------------------

## Knobs:  
  
In short:    
F0 52 00 4F 31 00 02 05 00 F7  
F0 52 00 4F 31 02 07 2A 00 F7  
F0 52 00 4F 31 xx yy zz 00 F7  
  
xx = Effectslot: 00=left 01=middle 02=right     
yy = Knobs per slot enumerate: start by 02=Module0(p.1) ... 04=Module2(p.1) ... 06=Module2(p.2) etc. / 01=direct selection   
zz = Effect value in hexadecimal    
  

Module0/Knob1/page1 to value 5: 
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 00 02 05 00 F7"  
Module1/Knob1/page1 to value 23:  
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 01 02 17 00 F7"  
Module2/Knob1/page1 to value 42:  
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 02 2A 00 F7"  
  
Mittlerer Knopf(1) für den linken Effekt auf den Wert 5:  
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 00 03 05 00 F7"  
Mittleren Knopf(1) für den mittleren Effekt auf den Wert 23:  
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 01 03 17 00 F7"  
Mittleren Knopf(1) für den rechten Effekt auf den Wert 42:  
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 03 2A 00 F7"  
  
Rechter Knopf für den linken Effekt auf den Wert 5  
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 00 04 05 00 F7"  
etc.  
x  
  
Module0/Knob1/page2 to value 5:  
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 00 05 05 00 F7"  
x  
x  
Module2/Knob3/page2 to value 42:  
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 02 07 2A 00 F7"  
  
Module0/Knob1/page3 to value 5:   
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 00 08 05 00 F7"  
etc.  
x  



## Global Mode:  
  
Flip signal path forward/backward (0x = 0 oder 1):    
F0 52 00 4F 31 03 09 0x 00 F7  


## Total Mode 
   

| Option | Command | 
| --- | --- | 
| Level    | F0 52 00 4F 31 03 02 xx 00 F7 |  
|Balance   | F0 52 00 4F 31 03 0A xx 00 F7 |
|          |                               |
|CTRL SW   | F0 52 00 4F 31 03 06 04 00 F7 |
| Unknown  |?F0 52 00 4F 31 03 07 00 00 F7? |   
  
  

change the order of the presets ???:  
  
  
   
  
  
  
  
## The 32er line:  
  
Store the current preset to D9 (27):   
amidi -p hw:2,0,0 -S "F0 52 00 4F 32 01 00 00 27 00 00 00 00 00 F7"  
  
Swap Patch from A1 (01) to D9 (27), store it and change to D9:  
amidi -p hw:2,0,0 -S "F0 52 00 4F 32 02 00 0 01 00 00 27 00 00 F7"  
  
  
Change patch in SysEx to G4 (40):  
amidi -p hw:2,0,0 -S "F0 52 00 4F 32 C0 40 F7"  
  
in Control Change:  
amidi -p hw:2,0,0 -S "C0 40"  
  
  
  
## Midi footpedal:
  
If you disable the lock, you get the value of a footpedal per SysEx.  
f0 52 00 4f 21 xx f7  
  
  
 
  
## SysEx of Death:  
   
If you send these messages, the ZFXB3 will crash, and have to reboot. Be careful!  
amidi -p hw:2,0,0 -S "F0 52 00 4F 31 03 0C 17 00 F7"  
amidi -p hw:2,0,0 -S "f0 52 00 4f 31 03 xx yy 00 f7"  
xx from 0C up to 1A / 1B okay, 1C & 1E not, 1F okay and then up to 2F is okay /  from 30 to ??? 7F it will crash again.    
yy = arbitrarily  
  
| xx | Result | 
| --- | --- | 
| 0B | okay  |  
| 0C | crash |  
| .. | crash |
| 1A | crash |
| 1B | okay  |
| 1C | crash |
| 1E | crash |
| 1F | okay  |
| 20 | crash |
| 21 | okay  |
| 22 | okay  |
| 23 | crash |
| 24 | crash |
| 25 | okay  |
| 26 | crash |
| 27 | crash |
| .. | crash |
... maybe it changes.   

  
  
# Appendix:  


## (1) The structure of a .b3p-file:  

```xml
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
  
  
```  
 
  
  
  
## (2) The structure of single patch representation:  

The representation of a whole fx-patch and a first try how I can parse it from/to the xml-file and transmit it to the device.    

F0 52 00 4F 28 20 7F 24 40 16 50 01 32 00 00 00 00 00 00 27 2E 10 40 00 10 02 00 00 00 08 00 00 00 28 26 40 02 00 00 00 0D 4C 2A 00 00 01 32 64 60 00 00 03 00 00 0C 4E 6F 69 73 65 47 00 46 75 7A 7A 00 F7  
Unlock device:  
amidi -p hw:2,0,0 -S "F0 52 00 4F 50 F7"	  
  
  
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
    
  
  
 

Foot Switch  mXp0  
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
  
```xml   
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
  
 
```
 
  
 
 
  
## (3) Request the global configuration :  
  
  
amidi -p hw:2,0,0 -S "F0 52 00 4F 2B F7"  
  
  
Different answers:  
f0 52 00 4f 2a 01 54 00 0f 58 00 00 10 00 01 00 19 00 f7  
f0 52 00 4f 2a 10 21 00 1d 54 00 00 40 00 01 00 19 00 f7    
f0 52 00 4f 2a 01 00 00 0a 5c 00 00 10 00 01 00 19 00 f7  
f0 52 00 4f 2a 00 64 40 21 51 00 60 48 00 00 04 19 00 f7   
  
  
    
for this case:  
f0 52 00 4f 2a 00 64 00 1e 56 00 00 40 00 01 00 19 00 f7  
  
Battery:  
...2a xx 64... / 00=Alkaline / 10=Ni-MH  
  
Level:  
... 2a 00 xx 00... (64 hex = 100 decimal)  
  
Signal Path:  
...64 00 00 1e 56 ... / 1e= ->1->2->3-> / 5e= <-1<-2<-3<- / different?       
  
Light:     
...00 64 xx 1e ... / 00=on 01=1sec ...0a=10sec etc.  
  
Rec Gain:  
...64 00 1e xx 00... / 0db=56 1db=57  
  
  
Rhythmus Level
...2a 0y 64 00 1e 56 00 00 xx 00... / 80=40(xx) / 81=44 / 82=48 /.../ 95=7c (max)  
...2a 01 64 00 1e 56 00 00 00 00... / 96=00(xx)+01(0y)  
...2a 01 64 00 1e 56 00 00 04 00... / 97  
...2a 01 64 00 1e 56 00 00 10 00... / 100  
  
Rhythm Pattern:  
...2a 0y 64 00 1e 56 00 x0 40 00... / x=00&y=00 = Guide / x=10&y=00 = 8Beat1 / x=up to 70   
...2a 02 64 00 1e 56 00 30 40 00... / x=30&y=02 = Metal2  
  
  
| BPM | Response | 
| --- | --- |
|  40 | f0 52 00 4f 2a 00 64 00 0a 56 00 00 40 00 01 00 19 00 f7 |  
|  41 | f0 52 00 4f 2a 00 64 40 0a 56 00 00 40 00 01 00 19 00 f7 | 
|  42 | f0 52 00 4f 2a 20 64 00 0a 56 00 00 40 00 01 00 19 00 f7 | 
|  43 | f0 52 00 4f 2a 20 64 40 0a 56 00 00 40 00 01 00 19 00 f7 | 
|  44 | f0 52 00 4f 2a 00 64 00 0b 56 00 00 40 00 01 00 19 00 f7 | 
| ... |                                                          |
| 127 | f0 52 00 4f 2a 20 64 40 1f 56 00 00 40 00 01 00 19 00 f7 | 
| 128 | f0 52 00 4f 2a 00 64 00 20 56 00 00 40 00 01 00 19 00 f7 | 
| 129 | f0 52 00 4f 2a 00 64 40 20 56 00 00 40 00 01 00 19 00 f7 | 
| ... |                                                          |
| 250 | f0 52 00 4f 2a 20 64 00 3e 56 00 00 40 00 01 00 19 00 f7 |  


Tuner:  
...2a 0y 64 00 1e xx 00... / 440Hz=56 / 441Hz=66 / 443Hz=06(xx)+08(0y)  
  
...1e 56 xx 0y... /Type Chromatic=00/Bassbx0=10 00/Bassbx1=10 01/Bassbx2= 10 02/Bassbx3= 10 03  
  
  
Looper:  
...40 00 01 00 19 00... / Level / in this case 100 
...40 00 xx yy zz 00...   
  
...40 00 01 0x 19 00... / Undo / 00=off 04=on  
  
...40 00 01 xx 19 00... / Stop Mode / Stop=00 Finish=08 FadeOut=10
  
Rhytmus Level (s.o)  
  
  
Flip signal path forward/backward (0x = 0 oder 1):    
F0 52 00 4F 31 03 09 0x 00 F7  





