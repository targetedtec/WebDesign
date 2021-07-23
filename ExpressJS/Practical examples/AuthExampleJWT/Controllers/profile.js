var connect = require('../DbConnection');
var jwt = require('jsonwebtoken');

const profile = function(req, res, next){

    try{
        console.log("profile section");
        
        //If no bearer token in request
        if(
            !req.headers.authorization ||
            !req.headers.authorization.startsWith('Bearer') ||
            !req.headers.authorization.split(' ')[1]
        ){
            return res.status(422).json({
                message: "Please provide the token",
            });
        }

        const theToken = req.headers.authorization.split(' ')[1];
        const decoded = jwt.verify(theToken, 'the-super-strong-secrect');
        connect.query('SELECT * FROM mysqltest.accounts where id = ?',[decoded.id],function(error,results,fields){
            if(results.length >0){
                //successfully 
                return res.json({
                    user: results[0],
                    error: []

                });
            }
            else{
                //unsuccessfull  
                return res.json({
                    error:["No user found"]
                });
            }
        });
    }
    catch(err){
        console.log(err);
    }
}

module.exports = profile;

