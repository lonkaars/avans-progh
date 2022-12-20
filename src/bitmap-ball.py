#!/bin/python3

from PIL import Image
import sys

WIDTH = 10
HEIGHT = 10

# return array of 12-bit color values (0bRRRGGGBBB)
def pixeldata():
  image = Image.open(sys.argv[-1]) # use last argument as input image file
  pixels = image.load()
  pixarr = []
  for x in range(WIDTH):
    for y in range(HEIGHT):
      color = pixels[x, y]
      crushed_color = ((color[0] >> 4) << 8 | (color[1] >> 4) << 4 | (color[2] >> 4) << 0)
      pixarr.append(crushed_color)
  return pixarr

if __name__ == "__main__":
  # get array of 12-bit pixels
  pixels = pixeldata()
  # declare rom_t as array with size len(pixels) and word width of 12 bits
  print(f"type rom_t is array (0 to {len(pixels) - 1}) of std_logic_vector(11 downto 0);")
  # format pixel value as x"rgb" (12-bit hexadecimal with padding)
  formatted_pixels = [f"x\"{hex(c)[2:].zfill(3)}\"" for c in pixels]
  # print constant bitmap_ball
  print(f"constant bitmap_ball: rom_t := ({', '.join(formatted_pixels)});")

