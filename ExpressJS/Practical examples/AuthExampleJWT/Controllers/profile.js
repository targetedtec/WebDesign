var connection = require('../DbConnection');
var jwt = require('jsonwebtoken');

const profile = function(req, res, next){

    try{
        console.log("profile section");
    }
    catch(err){
        console.log(err);
    }
}

module.exports = profile;

