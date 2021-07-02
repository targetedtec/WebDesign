var util = require('util');
var fs = require('fs');

// fs.readFile("./example.txt",function(err,data){
//     if(err) throw err;
    
//     util.log(data.toString());
//     console.log(data.toString());
//     //lines.push(data);
//      //callback(lines);
// });

function readfileCustom(filename,callback){
    let lines=[];

    fs.readFile(filename,function(err,data){
        if(err) throw err;
        
        console.log(data.toString());
        lines.push(data);
        callback(lines);
    });
    
}
//var a;
readfileCustom("./example.txt",function(data){
    //a= data;
    util.log("data:"+data);
});

readfileCustom("./example.txt",function(data){
    //a= data;
    util.log("data:"+data);
});

readfileCustom("./example.txt",function(data){
    //a= data;
    util.log("data:"+data);
});

