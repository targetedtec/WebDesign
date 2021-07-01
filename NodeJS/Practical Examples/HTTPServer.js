var http = require('http');
http.createServer(function (req, res) {
    console.log("Server is listensing now at 127.0.0.1:5000")
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Hello	World\n');
}).listen(5000, "127.0.0.1");
console.log("Server is going to up shortly!!")

