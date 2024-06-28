from machine import Pin, SPI
cs = Pin(5, Pin.OUT)
spi = SPI(2, baudrate=1_000_000, polarity=0, phase=0, sck=Pin(18), mosi=Pin(23), miso=Pin(19))
print(spi)

write_buffer = bytearray([0x01, 0x03, 0x07, 0xFF])
read_buffer  = bytearray(4)

cs(0)
spi.write_readinto(write_buffer, read_buffer)
cs(1)

for byte in read_buffer:
    print(f"{byte:02X}", end=" ")
    
# Można też tak
# cs(0)
# spi.write(b'\x01')
# spi.write(b'\x02')
# spi.write(b'\x04')
# spi.write(b'\x08')
# cs(1)
