/**
 * @file 烧录软盘
 * @author treelite(c.xinle@gmail.com)
 */

let fs = require('fs');

// 软盘容量
const MAX_LEN = 1474560

let files = process.argv.slice(2, -1);
let outputName = process.argv[process.argv.length - 1];

if (!files.length) {
    console.error('please input source files and output file');
    process.exit(1);
}

files = files.map(file => fs.readFileSync(file));
let maxLen = 0;
for (let file of files) {
    maxLen += files.length;
}

if (maxLen > MAX_LEN) {
    console.error('over max volume');
    process.exit(1);
}

files.push(Buffer.alloc(MAX_LEN - maxLen))
fs.writeFileSync(outputName, Buffer.concat(files, MAX_LEN));
