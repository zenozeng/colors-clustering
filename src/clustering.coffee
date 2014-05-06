color = require("color-convert")
CIEDE2000 = require("./CIEDE2000.coffee")
seeds = require("./seeds.coffee")

calcDistance = (lab1, lab2) -> CIEDE2000 lab1, lab2
calcCenter = (labs) ->

  calcScore = (guess) ->
    score = 0
    labs.forEach (lab) ->
      score += Math.pow(calcDistance(lab, guess), 2)
    score * -1

  minScore = 0
  newCenter = null

  for lab in labs
    score = calcScore(lab)
    if score < minScore
      minScore = score
      newCenter = lab

  newCenter

# pixels should be [[r, g, b], ...]
calcClusters = (pixels, config) ->
  # convert to lab
  pixels = pixels.map (rgba) ->
    [r, g, b, a] = rgba
    rgb = [r, g, b]
    if a isnt 255
      a /= 255
      rgb = rgb.map (elem) -> 255 * (1 - a) + elem * a
    color.rgb2lab(rgb)
  # init seeds
  centers = seeds.map (rgb) -> color.rgb2lab(rgb)
  # define iter
  iter = ->
    # init clusters
    clusters = []
    for i in [0...centers.length]
      clusters[i] = []
    # Distribute pixels
    for pixel in pixels
      # distribute current pixel to closest cluster
      minIndex = null
      minDistance = null
      centers.forEach (center, index) ->
        d = calcDistance(center, pixel)
        if (! minDistance?) or (d < minDistance)
          minIndex = index
          minDistance = d
      clusters[minIndex].push pixel
    # Remove clusters having no pixels
    clusters = clusters.filter (clusterPixels) -> clusterPixels.length > 0
    # Recalc centers
    centers = clusters.map (clusterPixels) -> calcCenter clusterPixels
    # Use random pixel as new center if clusters are not enough
    while centers.length < config.count
      centers.push pixels[parseInt(Math.random() * pixels.length)]
  iter()
  # iter()
  # iter()
  centers.map (lab) -> color.lab2rgb(lab)

module.exports = calcClusters
