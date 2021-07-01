// Importing the module library containing
// area and perimeter functions.
// " ./ " is used if both the files are in the same folder.

const lib = require('./exportlibrary');
//import * as lib from './exportlibrary.js';

debugger;
let length = 10;
let breadth = 5;

// Calling the functions
// defined in the lib module
lib.area(length, breadth);
lib.perimeter(length, breadth);

