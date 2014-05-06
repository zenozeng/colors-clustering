CIE76 = (lab1, lab2) ->
  sum = 0
  lab1.forEach (val, i) ->
    sum += Math.pow((val - lab2[i]), 2)
  Math.sqrt sum

module.exports = CIE76
