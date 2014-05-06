calcClusters = require("./clustering.coffee")

# the exposed interface
# config is {log: function, debug: true, maxWidth: 50, maxHeight: 50, src: imageurl}
clustering = (config, callback) ->

  defaultConfig =
    debug: off
    maxWidth: 30
    maxHeight: 30
    minCount: 1
  for k, v of config
    defaultConfig[k] = v
  config = defaultConfig

  img = new Image
  img.onload = ->
    image = this
    scale = Math.max (image.width / config.maxWidth), (image.height / config.maxHeight), 1

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
      pixels.push [imgData.data[i], imgData.data[i+1], imgData.data[i+2],imgData.data[i+3]]
      i += 4
    callback?(calcClusters(pixels, config))
  img.src = config.src

global.colorsClustering = clustering
