var express = require('express')
var login = require('./Controllers/login');
var register = require('./Controllers/register');
var profile = require('./Controllers/profile');
const {body,notempty} = require('express-validator');

var router = express.Router();

router.post('/auth',[
    body('username','Invalid username')
    .notempty()
    .trim(),
    body('password','Invalid password')
    .notempty()
    .trim()
    .isLength({min: 4})
],login);
router.post('/register',register);
router.get('/profile',profile);

module.exports = router;