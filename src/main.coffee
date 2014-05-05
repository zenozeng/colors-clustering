# the exposed interface
# config is {log: function, debug: true, maxWidth: 50, maxHeight: 50, src: imageurl}
clustering = (config, callback) ->
  defaultConfig =
    debug: off
    maxWidth: 50
    maxHeight: 50
    log: console.log
    count: 16
  for k, v in config
    defaultConfig[k] = v
  config = defaultConfig

  img = new Image
  img.onload ->
    image = this
    scale = Math.max (image.width / maxWidth), (image.height / maxHeight), 1

    [width, height] = [image.width, image.height].map (elem) -> parseInt (elem / scale)

    canvas = document.createElement("canvas");
    canvas.width = width
    canvas.height = height
    ctx = canvas.getContext "2d"
    ctx.drawImage this, 0, 0, image.width, image.height, 0, 0, width, height

    imgData = ctx.getImageData(0, 0, width, height)
    pixels = []
    i = 0
    while( i < imgData.data.length )
      pixels.push [imgData.data[i], imgData.data[i+1], imgData.data[i+2]]
      i += 4
    callback?(calcClusters(pixels, config))
  img.src = config.src

calcDistance = (lab1, lab2) -> CIDE2000 lab1, lab2
calcCenter = (labs) ->

  # 由于 CIEDE2000 算法只是对 l^2 + a^2 + b^2 下降做了一个系数修正
  # 所以显然，就像 z = x^2 + y^2，图像只有一个极值
  # 所以此处我们可以用最速下降法
  # Great thanks to Xero

  calcScore = (guess) ->
    score = 0
    labs.forEach (lab) ->
      score += Math.pow(calcDistance(lab, guess), 2)
    score * -1

# pixels should be [[r, g, b], ...]
calcClusters = (pixels, config) ->
  # convert to lab
  pixels = pixels.map (rgb) -> color.rgb2lab(rgb)
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
  iter()
  iter()
  centers

window.colorsClustering = clustering
