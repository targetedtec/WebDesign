var http = require('http');
var express = require('express');

var app= express();

app.use('/tom',(req,res)=>{
    res.write('Hello Tom');
    res.end();
});

app.use((req,res)=>{
    res.write('Hello World');
    res.end();
});

http.createServer(app).listen(3000);
