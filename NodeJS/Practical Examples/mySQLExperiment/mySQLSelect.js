const mysql = require('mysql');

const connection = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : '1234567',
    database : 'mySqlTest'
});

connection.connect(function(err) {
  if (err) throw err;
  connection.query("SELECT * FROM customers where address='test' ORDER BY name", function (err, result) {
    if (err) throw err;
    console.log(result);
  });
});