# Colors Clustering

Colors clustering based on K-means algorithm & CIE76.  
The seeds are extended color keywords from 
CSS Color Module Level 3 (W3C Recommendation 07 June 2011).

## Dev Requirements

```
npm install browserify
npm install coffeeify
```

## Usage

### Browser

```
window.colorsClustering({src: imgSrc}, function(colors) {
    // do sth here
});
```

see also: example/index.html

### NodeJS

TODO

### Example Output

```json
[
  {
    "color": [
      38,
      36,
      26
    ],
    "weight": 0.14166666666666666
  },
  {
    "color": [
      211,
      192,
      131
    ],
    "weight": 0.008333333333333333
  },
  {
    "color": [
      221,
      204,
      142
    ],
    "weight": 0.01875
  },
  {
    "color": [
      105,
      99,
      76
    ],
    "weight": 0.004166666666666667
  },
  {
    "color": [
      77,
      73,
      56
    ],
    "weight": 0.010416666666666666
  },
  {
    "color": [
      233,
      218,
      163
    ],
    "weight": 0.7708333333333334
  },
  {
    "color": [
      216,
      204,
      159
    ],
    "weight": 0.0020833333333333333
  },
  {
    "color": [
      232,
      218,
      161
    ],
    "weight": 0.035416666666666666
  },
  {
    "color": [
      159,
      147,
      105
    ],
    "weight": 0.004166666666666667
  },
  {
    "color": [
      197,
      184,
      144
    ],
    "weight": 0.004166666666666667
  }
] 
```

## FAQ

### Why not CIEDE2000

For performance issues.
Using CIEDE2000 is unbearable time-consuming.

### Is canvas(node) an optionalDependencie?

Yes, it is. If you only want to use this package in browser, 
it doesn't matter if you fail to npm install canvas.
