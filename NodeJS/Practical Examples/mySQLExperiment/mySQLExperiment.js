//step -1  for package.json file
//npm init --y

//Step-2 install packages
//npm install --save mysql

const mysql = require('mysql');
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '1234567'
});

connection.connect((err) => {
  if (err) throw err;
  console.log('Connected to MySQL Server!');
  connection.query("CREATE DATABASE mySQLTest", function (err, result) {
    if (err) throw err;
    console.log("Database created");
  });
});