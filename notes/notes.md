## Notes from 6502 project

##### [Software for assembling](http://sun.hasenbraten.de/vasm/)
Compile with: ```make CPU=6502 SYNTAX=oldstyle```

Run with: ```./vasm6502_oldstyle -Fbin -dotdir <example>.s```
```./vasm6502_oldstyle -Fbin -dotdir helloworld.s && hexdump -C a.out```

##### Command to program eeprom:
```minipro -p 28C256 -uP -w a.out```

##### Command to display binary file:
```hexdump -C rom.bin```


##### Ben Eater 6502 current video location
Interrupt handling

##### Arduino hook up
Address lines are in reverse ascending order 
so are data lines
dont forget clock, ground and read/write mode pin

##### Helful link
[Hex to binary](https://www.rapidtables.com/convert/number/hex-to-binary.html)

#### Assembly notes
- $ or 0x means hex, % or 0b means binary
- "#" means load immediate


#### Thoughts
- Bit of survivorship bias in the note taking process. what you write down you remember, so it feels like you dont need to write things down. lol

- Tristate = High impedance.
So for communication between chips, the pins first need to be set to either tristate or low impedance, then they get written to wherever they're going. 
So I'm a CPU whos gonna read from some RAM.
I'm gonna let the RAM be read from (write enable goes high)
Yo this is the shit I need (setting address). 
Yo RAM get ready for me to read you (chip select goes low). 
Now let me read you (Output enable goes low). 
Okay done reading you (CS high, then OE high, then WE stays high..)\
At a neutral state the the RAM has its output enable and write enable pin high. That way it does neither. (the yare both active low)

- The only thing that writes to the address bus is the CPU

- baud rate vs clock speed?


#### ollama set up
oco config set OCO_AI_PROVIDER='ollama' OCO_MODEL='mistral'
oco config set OCO_API_URL=http://localhost:11434/api/chat

#### RAM and bus timing notes
- [This image helped with understanding](https://electronics.stackexchange.com/questions/107183/meaning-of-control-pins-ce-oe-we) ![alt text](1.jpg)
- ![alt text](2.png)
- I suppose it's okay if the addresses are not valid and the write enable pin gets set 

- [this reddit post with the memory map was good ](https://www.reddit.com/r/beneater/comments/doytpo/6502_project_memory_map/) 

0x0000 - 0x3fff = RAM
0x4000 - 0x5fff = Open Bus (Invalid Memory Addresses)
0x6000 = I/O Register B
0x6001 = I/O Register A
0x6002 = Data Direction Register B
0x6003 = Data Direction Register A
0x6004 = T1 Low Order Latches/Counter
0x6005 = T1 High Order Counter
0x6006 = T1 Low Order Latches
0x6007 = T1 High Order Latches
0x6008 = T2 Low Order Latches/Counter
0x6009 = T2 High Order Counter
0x600a = Shift Register
0x600b = Auxiliary Control Register
0x600c = Peripheral Control Register
0x600d = Interrupt Flag Register
0x600e = Interrupt Enable Register
0x600f = I/O Register A sans Handshake (I do not believe this computer uses Handshake anyway.)
0x6010 - 0x7fff - Mirrors of the sixteen VIA registers
0x8000 - 0xffff = ROM

- im trying out cursor now. its vs code with continue but a bit better because it uses cursor tab

#### Binary to decimal notes
The operation performed by SBC is:
A = A - M - (1 - C)

Case 1: Carry Flag Initially Set (C = 1)

    Initial State: A = 0, M = 0, C = 1.
    Operation: A = 0 - 0 - (1 - 1) = 0 - 0 - 0 = 0.
    Result: A = 0.
    Carry Flag: Since the result is zero (non-negative), the Carry flag remains set (C = 1).

Case 2: Carry Flag Initially Clear (C = 0)

    Initial State: A = 0, M = 0, C = 0.
    Operation: A = 0 - 0 - (1 - 0) = 0 - 0 - 1 = -1.
    Result: A = 255 (since -1 in 8-bit unsigned arithmetic is represented as 255).
    Carry Flag: Since the result is negative (in terms of signed interpretation), the Carry flag remains clear (C = 0).

#### interrupt notes
the reason we're using the VIA for the interrupt is because you can kind of do software debouncing with it 