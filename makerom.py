# initialize bite array with 0xea which is the 'no operation' function
rom = bytearray([0xea] * 32768)

rom[0] = 0xa9
rom[1] = 0x42

rom[2] = 0x8d
rom[3] = 


#reset vector set up, send to address '1000000000000000' leading zero is for EEPROM chip enable
rom[0x7ffc] = 0x00 
rom[0x7ffd] = 0x80

# create binary file for uploading with given array
with open ("rom.bin", "wb") as out_file:
    out_file.write(rom);