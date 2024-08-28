# initialize bite array with 0xea which is the 'no operation' function
rom = bytearray([0xea] * 32768)

# start program
rom[0] = 0xa9 # load accumulator with memory
rom[1] = 0x42 # memory

rom[2] = 0x8d # store accumulator in memory
rom[3] = 0x00 # memory
rom[4] = 0x60 # memory

# reset vector set up (reset vector is first memory location gone to by default, the program goes to whatever is in the reset vector then counts up)
# Send to address '1000000000000000' leading zero is for EEPROM chip enable
rom[0x7ffc] = 0x00 # points to address 8000
rom[0x7ffd] = 0x80

# create binary file for uploading with given array
with open ("rom.bin", "wb") as out_file:
    out_file.write(rom) 