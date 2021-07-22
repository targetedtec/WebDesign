var express= require('express');
var app = express();
var routes= require('./routes');
var path = require('path');


app.use(routes);
//For default page
app.get('/',function(request, response){
    response.sendFile(path.join(__dirname+'/login.html'));
});

app.listen(3000,()=>{
    console.log("Server is running on port 3000");
});