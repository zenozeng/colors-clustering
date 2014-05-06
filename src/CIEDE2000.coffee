math = require('mathjs')()

# see also: http://en.wikipedia.org/wiki/Color_difference
# see also: http://www.ece.rochester.edu/~gsharma/ciede2000/ciede2000noteCRNA.pdf

CIEDE2000 = (lab1, lab2) ->

  # default parametric factors
  # see also: http://www.ece.rochester.edu/~gsharma/ciede2000/dataNprograms/deltaE2000.m
  kL = 1
  kC = 1
  kH = 1

  [L1, a1, b1] = lab1
  [L2, a2, b2] = lab2
  deltaL = L2 - L1
  L = (L1 + L2) / 2
  C1 = Math.sqrt(a1 * a1 + b1 * b1)
  C2 = Math.sqrt(a2 * a2 + b2 * b2)
  C = (C1 + C2) / 2
  deltaC = C2 - C1
  h1 = Math.atan(b1, a1) * 180 / Math.PI
  h1 += 360 if h1 < 0
  h2 = Math.atan(b2, a2) * 180 / Math.PI
  h2 += 360 if h2 < 0
  abs = Math.abs(h1 - h2)
  if abs <= 180
    deltah = h2 - h1
  else if (abs > 180) and (h2 <= h1)
    deltah = h2 - h1 + 360
  else
    deltah = h2 - h1 - 360
  deltaH = 2 * Math.sqrt(deltah * Math.PI / 360)
  if abs > 180
    H = (h1 + h2 + 360) / 2
  else
    H = (h1 + h2) / 2
  T = 1 - 0.17 * math.cos(math.unit((H - 30), 'deg'))
  T += 0.24 * math.cos(math.unit((2 * H), 'deg'))
  T += 0.32 * math.cos(math.unit((3 * H + 6), 'deg'))
  T -= 0.20 * math.cos(math.unit((4 * H - 63), 'deg'))
  SL = 1 + 0.015 * (L - 50) * (L - 50) / Math.sqrt(20 + (L - 50) * (L - 50))
  SC = 1 + 0.045 * C
  SH = 1 + 0.015 * C * T
  RT = -2 * Math.sqrt(Math.pow(C, 7) / (Math.pow(C, 7) + Math.pow(25, 7)))
  RT *= math.sin(math.unit((60 * Math.exp( -1 * Math.pow(((H - 275) / 25), 2))), 'deg'))
  deltaE = Math.pow((deltaL / (kL * SL)), 2)
  deltaE += Math.pow((deltaC / (kC * SC)), 2)
  deltaE += Math.pow((deltaH / (kH * SH)), 2)
  deltaE += RT * deltaC * deltaH / (kC * SC * kH * SH)
  deltaE = Math.sqrt(deltaE)

module.exports = CIEDE2000
