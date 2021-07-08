const mysql = require('mysql');

const connection = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : '1234567',
    database : 'mySqlTest'
});

function callSP(spName) {
    let spQuery = 'CALL ??';
    let query = mysql.format(spQuery,[spName]);
    // CALL `getAllCustomers`
    connection.query(query,(err, result) => {
        if(err) {
            console.error(err);
            return;
        }
        // rows from SP
        console.log(result);
    });
}

// timeout just to avoid firing query before connection happens

setTimeout(() => {
    // call the function
    // call sp
    callSP('getAllCustomers')
},5000);

//store procedure
 
// DELIMITER $$
 
// CREATE PROCEDURE `getAllCustomers`()
// BEGIN
//     SELECT * FROM todo;
// END$$
 
// DELIMITER ;