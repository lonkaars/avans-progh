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
  # coe file header
  print("memory_initialization_radix=16;\nmemory_initialization_vector=", end='')
  # format pixel value as 12-bit hexadecimal with padding seperated by comma and space
  formatted_pixels = ','.join([f"{hex(c)[2:].zfill(3)}" for c in pixels])
  print(f"{formatted_pixels};")


