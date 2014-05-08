color = require("color-convert")
calcDistance = require("./CIE76.js")
seeds = require("./seeds.js")

calcCenter = (labs) ->

  [L, A, B] = [0, 0, 0]
  labs.forEach (lab) ->
    L += lab[0]
    A += lab[1]
    B += lab[2]

  len = labs.length
  L /= len
  A /= len
  B /= len

  minDistance = null
  newCenter = null

  for lab in labs
    d = calcDistance [L, A, B], lab
    if (!newCenter?) or (d > minDistance)
      minDistance = d
      newCenter = lab

  newCenter

# pixels should be [[r, g, b, a], ...]
calcClusters = (pixels, config) ->

  start = (new Date()).getTime()

  log = (title, colors = []) ->
    if config.debug
      config.log?(title, colors.map (lab) -> color.lab2rgb(lab))

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
  log("Seeds", centers);
  # define iter
  clusters = null
  iter = (removeEmptyClusters = true, useRandomPixels = true) ->
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
    if removeEmptyClusters
      clusters = clusters.filter (clusterPixels) -> clusterPixels.length > 0
    # re calc centers
    centers = clusters.map (clusterPixels) -> calcCenter clusterPixels
    # Use random pixel as new center if clusters are not enough, DONE
    if useRandomPixels
      while centers.length < config.minCount
        centers.push pixels[parseInt(Math.random() * pixels.length)]
    log("New Clusters", centers)
  iter()
  iter()
  iter()
  iter(removeEmptyClusters = false, useRandomPixels = false)
  centers = centers.map (lab) ->
    color.lab2rgb(lab)
  end = (new Date()).getTime()
  log("Calc #{centers.length} clusters in #{end - start}ms")
  centers.map (center, i) ->
    weight = clusters[i].length / pixels.length
    {color: center, weight: weight}

module.exports = calcClusters
