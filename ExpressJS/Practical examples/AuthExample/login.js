var express= require('express');
var mysql= require('mysql');
var path= require('path');
var bodyParser= require('body-parser');
var session = require('express-session');
var connection = require('./DbConnection');

var app = express();

app.use(session({
    secret: 'asdfghqwerty',
    resave: true,
    saveUninitialized: true
}));

app.use(bodyParser.urlencoded({extended : true}));
app.use(bodyParser.json());

//For default page
app.get('/',function(request, response){
    response.sendFile(path.join(__dirname+'/login.html'));
});

//For login endpoint
app.post('/auth',function(request, response){
    var userName = request.body.username;
    var password = request.body.password;
    if(userName && password){
        //validate my credentials in my mysql database
        connection.query('SELECT * FROM mysqltest.accounts where username = ? and password = ?',[userName, password],function(error,results,fields){
            if(results.length >0){
                //successfully authenticated
                request.session.loggedIn = true;
                request.session.userName = userName;
                response.redirect('/home');
            }
            else{
                response.send("Incorrect username and password");
            }
            response.end();
        });

    }
    else{
        response.send("please enter username and password");
        response.end();
    }
});


//For Home endpoint, after login successfully
app.get('/home',function(request, response){
    if(request.session.loggedIn){
        response.send("Welcome"+ request.session.userName+" !!");
    }else{
        response.send("Please login first by valid credentials!!");
    }
    response.end();
    //getting customers
    // connection.query('SELECT * FROM mysqltest.accounts where username = ? and password = ?',[userName, password],function(error,results,fields){
    //     if(results.length >0){
    //         //successfully authenticated and showing customers
    //         response.send(`
    //             <h1>Total number of customers </h1>
    //         `);
    //     }
    //     else{
    //         response.send("getting error");
    //     }
    //     response.end();
    // });
});

app.listen(3000);