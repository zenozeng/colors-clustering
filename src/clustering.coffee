color = require("color-convert")
calcDistance = require("./CIE76.coffee")
seeds = require("./seeds.coffee")

calcCenter = (labs) ->

  calcDistanceSum = (guess) ->
    score = 0
    labs.forEach (lab) ->
      score += Math.pow(calcDistance(lab, guess), 2)
    score

  minDistance = null
  newCenter = null

  for lab in labs
    d = calcDistanceSum(lab)
    if (!newCenter?) or (d > minDistance)
      minDistance = d
      newCenter = lab

  newCenter

# pixels should be [[r, g, b, a], ...]
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
    # remove empty clusters
    clusters = clusters.filter (clusterPixels) -> clusterPixels.length > 0
    # re calc centers
    centers = clusters.map (clusterPixels) -> calcCenter clusterPixels
    # Use random pixel as new center if clusters are not enough, DONE
    while centers.length < config.count
      centers.push pixels[parseInt(Math.random() * pixels.length)]
  iter()
  # iter()
  # iter()
  console.log "final"
  console.log centers
  centers.map (lab) ->
    console.log lab
    color.lab2rgb(lab)

module.exports = calcClusters
