var	querystring	=require('querystring');
var	result	=querystring.stringify({ foo:	'bar',	baz:  ['qux',	'quux'], corge:	''	});
console.log(result);
result =	"\n"	+querystring.stringify({foo:	'bar',	baz: 'qux'}, ';',	':');
console.log(result);
let result1	= querystring.parse('foo=bar&baz=qux&baz=quux&corge');
console.log(result1);
