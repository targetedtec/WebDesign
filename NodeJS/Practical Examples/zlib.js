var fs = require('fs');
var zlib = require('zlib');
let r	=	fs.createReadStream('example.txt');
let  z	=	zlib.createGzip();
let w	=	fs.createWriteStream('file.txt.gz');
r.pipe(z).pipe(w);


