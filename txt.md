## Notes from 6502 project

Command to program eeprom:
```minipro -p 28C256 -uP -w rom.bin```

Command to display binary file:
```hexdump -C rom.bin```

### Current Video location
part 2 31.01 

### Arduino hook up

address lines are in reverse ascending order 
so are data lines
dont forget clock, ground and read/write mode pin
