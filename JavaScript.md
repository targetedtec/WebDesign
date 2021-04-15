# Berief Introduction to JavaScript

Unlike most programming languages, the JavaScript language has no concept of input or output. It is designed to run as a scripting language in a host environment, and it is up to the host environment to provide mechanisms for communicating with the outside world. The most common host environment is the browser, but JavaScript interpreters can also be found in a huge list of other places, including Adobe Acrobat, Adobe Photoshop, SVG images, Yahoo's Widget engine, server-side environments such as Node.js, NoSQL databases like the open source Apache CouchDB, embedded computers, complete desktop environments like GNOME (one of the most popular GUIs for GNU/Linux operating systems), and others.

## Overview

JavaScript is a multi-paradigm, dynamic language with types and operators, standard built-in objects, and methods. Its syntax is based on the Java and C languages — many structures from those languages apply to JavaScript as well. JavaScript supports object-oriented programming with object prototypes, instead of classes (see more about prototypical inheritance and ES2015 classes). JavaScript also supports functional programming — because they are objects, functions may be stored in variables and passed around like any other object.

Let's start off by looking at the building blocks of any language: the types. JavaScript programs manipulate values, and those values all belong to a type. JavaScript's types are:

- Number
- String
- Boolean
- Function
- Object
- Symbol (new in ES2015)

and undefined and null, which are ... slightly odd. And Array, which is a special kind of object. And Date and RegExp, which are objects that you get for free. And to be technically accurate, functions are just a special type of object. So the type diagram looks more like this:

- Number
- String
- Boolean
- Symbol (new in ES2015)
- Object
- Function
- Array
- Date
- RegExp
- null
- undefined

And there are some built-in Error types as well. Things are a lot easier if we stick with the first diagram, however, so we'll discuss the types listed there for now.

Numbers
ECMAScript has two built-in numeric types: 
- Number and 
- BigInt.

The Number type is a double-precision 64-bit binary format IEEE 754 value (numbers between -(253 − 1) and 253 − 1). And where this article and other MDN articles refer to “integers”, what’s usually meant is a representation of an integer using a Number value. But because such Number values aren’t real integers, you have to be a little careful. For example:
