
var jwt = require('jsonwebtoken');
var {validationResult}= require('express-validator');
var connect = require('../DbConnection')

const login = function(req, res, next){
    try{
        console.log("login section");

        const errors= validationResult(req);

        if(!errors.isEmpty()){
            return res.status(422).json({ errors: errors.array() });
        }

        var userName = req.body.username;
        var password = req.body.password;
        connect.query('SELECT * FROM mysqltest.accounts where username = ? and password = ?',[userName, password],function(error,results,fields){
            if(results.length >0){
                //successfully authenticated
                const token = jwt.sign({id: results[0].id},'the-super-strong-secrect',{expiresIn: '1h'});
                return res.json({
                    token: token
                });
            }
            else{
                //unsuccessfull to authenticate 

            }

        });
    }
    catch(err){
        console.log(err);
    }
}

module.exports = login;

