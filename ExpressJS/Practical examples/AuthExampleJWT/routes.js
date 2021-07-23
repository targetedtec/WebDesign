var express = require('express')
const {body} = require('express-validator');
var login = require('./Controllers/login');
var register = require('./Controllers/register');
var profile = require('./Controllers/profile');


var router = express.Router();

router.post('/auth',[
    body('username','Invalid username').notEmpty().trim(),
    body('password','Invalid password').notEmpty().trim().isLength({min: 4})
],login);
router.post('/register',register);
router.get('/profile',profile);

module.exports = router;