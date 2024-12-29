from framebuf import *
from time import sleep_ms, ticks_ms
from machine import Pin, SPI

cs = Pin(5, Pin.OUT)
dc = Pin(21, Pin.OUT, value=1)
spi = SPI(2, baudrate=10_000_000, polarity=0, phase=0, sck=Pin(18), mosi=Pin(23), miso=Pin(19))
print(spi)

WIDTH  = 128
HEIGHT = 96

array  = bytearray(WIDTH * HEIGHT // 8)
buffer = FrameBuffer(array, WIDTH, HEIGHT, MONO_VLSB)

def transmit():
    cs(0)
    spi.write(array)
    cs(1)

def lines_demo(loops):
    from random import randrange
    
    x1 = 0
    y1 = 0
    
    start_time = ticks_ms()
    for i in range(loops):
        x2 = randrange(WIDTH)
        y2 = randrange(HEIGHT)
        buffer.line(x1, y1, x2, y2, 1)
        transmit()
        x1 = x2
        y1 = y2
    
    end_time = ticks_ms()
    work_time = end_time - start_time
    frame_time = work_time / loops
    
    print(f"Frame time: {frame_time} ms")
    print(f"Frame rate: {1000/frame_time} fps")

def pixels_demo(loops):
    from random import randrange
    
    start_time = ticks_ms()
    for i in range(loops):
        x = randrange(WIDTH)
        y = randrange(HEIGHT)
        buffer.pixel(x, y, 0) # black pixel
        x = randrange(WIDTH)
        y = randrange(HEIGHT)
        buffer.pixel(x, y, 1) # white pixel
        transmit()
    
    end_time = ticks_ms()
    work_time = end_time - start_time
    frame_time = work_time / loops
    
    print(f"Frame time: {frame_time} ms")
    print(f"Frame rate: {1000/frame_time} fps")
    
def chess_demo():
    for x in range(0, WIDTH * HEIGHT / 8, 2):
        array[x]   = 0b01010101 
        array[x+1] = 0b10101010
        

lines_demo(50)
#pixels_demo(100000)
#chess_demo()
transmit()

