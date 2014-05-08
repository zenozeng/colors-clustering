coffee -o ./ -c src/index.coffee
coffee -o ./lib/ -c src/lib/*
browserify index.js > browser.js
