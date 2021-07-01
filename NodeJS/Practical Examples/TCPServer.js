var net = require('net');
net.createServer(function (socket) {
    console.log("Server is listensing now at 127.0.0.1:6000")
    socket.write("Echo!!");
    socket.pipe(socket);
}).listen(6000, "127.0.0.1");
console.log("Server is going to up shortly!!")

