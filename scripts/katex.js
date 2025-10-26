var katex = require("katex");
var fs = require("fs");
var input = fs.readFileSync(0);
var displayMode = process.env.DISPLAY != undefined;
console.log("KaTeX DISPLAY MODE: " + displayMode ? process.enc.DISPLAY : "")

var html = katex.renderToString(String.raw`${input}`, {
    throwOnError : false,
    displayModed : displayMode
});

console.log(html)
