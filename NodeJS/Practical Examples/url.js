var url = require('url');

var result = url.parse('http://user:pass@host.com:8080/p/a/t/h?query=string#hash');
console.log(result);
