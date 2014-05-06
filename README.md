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

```
window.colorsClustering({src: imgSrc}, function(colors) {
    // do sth here
});
```

see also: example/index.html

## FAQ

### Why not CIEDE2000

For performance issues.
Using CIEDE2000 is unbearable time-consuming.
