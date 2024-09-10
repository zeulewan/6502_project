def flip_bit(number, position):
    # Create a mask to isolate the bit at 'position'
    mask = 1 << position
    # XOR the number with the mask to flip the bit
    flipped_number = number ^ mask
    return flipped_number

# Example usage:
number = 0b1010101010101010  # Example 16-bit binary number
position_to_flip = 11         # Bit position to flip (0-based index)

flipped_number = flip_bit(number, position_to_flip)

print(f"Original number:   {bin(number)}")
print(f"Flipped number:    {bin(flipped_number)}")
