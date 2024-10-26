from framebuf import *
from machine import Pin, SPI

cs = Pin(5, Pin.OUT)
dc = Pin(21, Pin.OUT, value=1)
spi = SPI(2, baudrate=10_000_000, polarity=0, phase=0, sck=Pin(18), mosi=Pin(23), miso=Pin(19))
print(spi)

WIDTH  = 128
HEIGHT = 96

array  = bytearray(WIDTH * HEIGHT // 8)
buffer = FrameBuffer(array, WIDTH, HEIGHT, MONO_VLSB)

def simulate():
    for y in range(HEIGHT):
        print(f"{y}\t", end="")
        for x in range(WIDTH):
            bit  = 1 << (y % 8)
            byte = array[(y // 8) * WIDTH + x]
            pixel = "#" if byte & bit else "."
            print(pixel, end="")
        print("")

def transmit():
    cs(0)
    spi.write(array)
    cs(1)

def demo():
    buffer.text('Elektronika', 0, 1, 1)
    buffer.text('Praktyczna', 48, 9, 1)

    buffer.rect(28, 22, 76, 11, 1)
    buffer.text('Kurs FPGA', 30, 24, 1)

    buffer.rect(0, 42, 128, 54, 1)
    buffer.text('abcdefghijklm', 1, 44, 1)
    buffer.text('nopqrstuvwxyz', 1, 53, 1)
    buffer.text('ABCDEFGHIJKLM', 1, 62, 1)
    buffer.text('NOPQRSTUVWXYZ', 1, 70, 1)
    buffer.text('0123456789+-*/', 1, 78, 1)
    buffer.text('!@#$%^&*(),.<>?', 1, 86, 1)

demo()
simulate()
transmit()
