var cheerio = require('cheerio');
var rp = require('request-promise');

var output = [];
var options = {
    url: 'https://targetedtec.com/',
    transform: body => cheerio.load(body)
}

rp(options).then(($) => {
        process.stdout.write('loading');
        try {
            var spanContainers = $('div.et_pb_text_inner ul li span');
            for (let i = 0; i < spanContainers.length; i++) {
                var element = $('div.et_pb_text_inner ul li span')[i];
                var content ="";
                for (var child in element.children){
                    let data = element.children[child].data;
                    if(data){
                        content += data;
                    }
                }
                output.push(content);
            }
            console.log(output.toString());
        } catch (e) {
            console.log(e.toString());
        }
    })
    .catch((err) => {
        console.log(err);
    });