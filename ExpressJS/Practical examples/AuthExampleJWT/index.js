var express= require('express');
var routes= require('./routes');
var path = require('path');
var app = express();

app.use(express.json());

app.use(routes);

// Handling Errors
app.use((err, req, res, next) => {
    // console.log(err);
    err.statusCode = err.statusCode || 500;
    err.message = err.message || "Internal Server Error";
    res.status(err.statusCode).json({
      message: err.message,
    });
});

//For default page
app.get('/',function(request, response){
    response.sendFile(path.join(__dirname+'/login.html'));
});

app.listen(3000,()=>{
    console.log("Server is running on port 3000");
});