const mysql= require('mysql');

const Db_connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '1234567',
    database: 'mySqlTest'
}).on("error",(err)=>{
    console.log("Failed to connect with database", err);
});

module.exports = Db_connection;