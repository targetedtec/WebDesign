
var dns = require('dns');
var util= require('util');

dns.lookup('www.targetedtec.com', function onLookup(err, addresses, family) {
    util.log('addresses:', addresses);
});

dns.resolve4('www.targetedtec.com', function (err, addresses) {
    if (err) throw err;
    util.log('addresses: ' + JSON.stringify(addresses));
    addresses.forEach(function (a) {
        dns.reverse(a, function (err, domains) {
            if (err) { throw err; }
            util.log('reverse for ' + a + ': ' + JSON.stringify(domains));
        });
    });
});

