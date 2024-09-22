## Notes from 6502 project

##### Command to program eeprom:
```minipro -p 28C256 -uP -w rom.bin```

##### Command to display binary file:
```hexdump -C rom.bin```

##### [Software for assembling](http://sun.hasenbraten.de/vasm/)
Compiled with: ```make CPU=6502 SYNTAX=oldstyle```
Run with: ```./vasm6502_oldstyle -Fbin -dotdir <example>.s```

##### Ben Eater 6502 current video location
part 4 0:00 

##### Arduino hook up
Address lines are in reverse ascending order 
so are data lines
dont forget clock, ground and read/write mode pin

##### Helful link
[Hex to binary](https://www.rapidtables.com/convert/number/hex-to-binary.html)

#### Assembly notes
- $ or 0x means hex, % or 0b means binary
- "#" means load immediate


bit of survivorship bias in the note taking process. what you write down you remember, so it feels like you dont need to write things down. lol