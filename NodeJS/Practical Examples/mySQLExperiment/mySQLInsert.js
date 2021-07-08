const mysql = require('mysql');
const logger = require('./utils/logger');

const connection = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : '1234567',
    database : 'mySqlTest'
});

connection.connect(function(err) {
    if (err) throw err;
    logger.log('info', 'successfully connected');
    var sql = "INSERT INTO customers (name, address) VALUES ('test name', 'test address')";
    connection.query(sql, function (err, result) {
        if (err){ 
            logger.log("error",err);
            throw err;
        }
        logger.log("info","1 record inserted");
  });
});