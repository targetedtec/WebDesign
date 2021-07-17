var http = require('http');
var express = require('express');

var app = express();
var router = express.Router();

router.get('/profile',(req,res)=>{
    res.write('Profile');
    res.end();
});

router.get('/status',(req,res)=>{
    res.write('Status');
    res.end();
});

router.get('/profile/:name',(req,res)=>{
    res.write('Hello'+ req.params.name);
    res.end();
});

app.use('/user', router);

app.use((req,res)=>{
    res.write('Dashbaord page');
    res.end();
});
http.createServer(app).listen(3000);


