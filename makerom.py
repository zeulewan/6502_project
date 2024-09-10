code = bytearray([
    # VIA B register output
    0xa9, 0xff # load accumulator with memory, memory
    0x8d, 0x02, 0x60 # store accumulator in address, register, register

    # wire 0x99 to VIA B register
    0xa9, 0x99 
    0x8d, 0x00, 0x60

])

# init bite array with 0xea which is the 'no operation' function
rom = bytearray([0xea] * (32768 - len(code)))


## reset vector set up (reset vector is first memory location gone to by default, 
# the program goes to whatever is in the reset vector then counts up)
# Send to address '1000000000000000' leading zero is for EEPROM chip enable
rom[0x7ffc] = 0x00 # points to address 8000
rom[0x7ffd] = 0x80

# create binary file for uploading with given array
with open ("rom.bin", "wb") as out_file:
    out_file.write(rom) 