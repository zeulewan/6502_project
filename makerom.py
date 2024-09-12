code = bytearray([
    0xa9, 0xff, # lda #$ff
    0x8d, 0x02, 0x60, # sta $6002

    0xa9, 0b10010010, # lda #$92
    0x8d, 0x00, 0x60, # sta $6000

    0xea, 0xea, 0xea,

    0xa9, 0b01001001, # lda #$49
    0x8d, 0x00, 0x60, # sta $6000

    0xea, 0xea, 0xea,

    0xa9, 0b00100100, # lda #$12
    0x8d, 0x00, 0x60, # sta $6000

    # loop
    0x4c, 0x05, 0x80
    ])

# init bite array with 0xea which is the 'no operation' function
rom = code + bytearray([0xea] * (32768 - len(code)))


## reset vector set up (reset vector is first memory location gone to by default, 
# the program goes to whatever is in the reset vector then counts up)
# Send to address '1000000000000000' leading zero is for EEPROM chip enable
rom[0x7ffc] = 0x00 # points to address 8000
rom[0x7ffd] = 0x80

# create binary file for uploading with given array
with open ("rom.bin", "wb") as out_file:
    out_file.write(rom) 