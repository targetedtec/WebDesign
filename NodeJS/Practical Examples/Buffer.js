var util = require('util');
buf	= Buffer.alloc(10);  

buf.write("abcdefghj",	0,	"ascii");  
util.log(buf.toString('base64'));  

buf	=	buf.slice(0,5);  
util.log(buf.toString('utf8'));
