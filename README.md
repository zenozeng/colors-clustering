# Colors Clustering

Colors clustering based on K-means algorithm & CIE76.  
The seeds are extended color keywords from 
CSS Color Module Level 3 (W3C Recommendation 07 June 2011).

## Usage

### Get img src

You can use

- Url

- Data Url

- URL.createObjectURL(FileObj)

### Browser

Include browser.js.

```javascript
window.colorsClustering({src: imgSrc}, function(colors) {
    // do sth here
});
```

see also: example/index.html

### NodeJS or Browserify

```
npm install colors-clustering
```

```javascript
var colorsClustering = require("colors-clustering");
colorsClustering({src: imgSrc}, function(colors) {
    // do sth here
});
```

### Config

```javascript
var config = {
    debug: true,
    log: function(msg, colors) {
        console.log(msg);
        colors.map(function(rgb) {
            console.log(rgb);
        });
    },
    maxWidth: 30,
    maxHeight: 30,
    minCount: 1,
    src: imgSrc
};
colorsClustering(config, callback);
```

The image will be resized based on maxWidth and maxHeight.
And the number of output colors will be always >= minCount.
If debug is on, the log will be called.

### Example Output

Note: Color is [r, g, b], and the weight depends on the size of cluster.

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

## License (MIT)

Copyright (c) 2014 Zeno Zeng

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*This program incorporates work covered by the following copyright and permission notices:*

- canvas-browserify

    Copyright (c) 2013 Dominic Tarr

    MIT License
    
- color-convert

    Copyright (c) 2011-2014 harthur

    MIT License

## FAQ

### Why not CIEDE2000

For performance issues.
Using CIEDE2000 is unbearable time-consuming.

### Is canvas(node) an optionalDependencie?

Yes, it is. If you only want to use this package in browser, 
it doesn't matter if you fail to npm install canvas.
