var crypto = require('crypto');
var fs = require('fs');
var util = require('util');
// var shasum = crypto.createHash('sha1'); 
// var s = fs.ReadStream('example.txt'); 
// s.on('data', function (d) {
//     shasum.update(d);
// });
// s.on('end', function () {
//     var d = shasum.digest('hex'); 
//     util.log(d + '	file.txt');
// });

//create cipher/encryption
var mykey = crypto.createCipher('aes-128-cbc', 'mypassword');
var mystr = mykey.update('abc', 'utf8', 'hex')
mystr += mykey.final('hex');

util.log(mystr);

//Decrpt
var mykey = crypto.createDecipher('aes-128-cbc', 'mypassword');
var mystr = mykey.update('34feb914c099df25794bf9ccb85bea72', 'hex', 'utf8')
mystr += mykey.final('utf8');

util.log(mystr);
