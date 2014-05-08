coffee -o ./ -c src/*.coffee
coffee -o ./lib/ -c src/lib/*
browserify browser.js > browser/colors-clustering.js
