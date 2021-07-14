var http = require('http');
var formidable = require('formidable');
var fs = require('fs');

//Step: 1 => Create http server and upload form
//Step -2 => upload a file or parse a file
//Step -3 => Save the file
http.createServer(function (req, res) {
    if (req.url == '/fileUpload') {
        var form = new formidable.IncomingForm();
        form.parse(req, function (err, fields, files) {
            var oldpath = files.filetoUpload.path;
            var newpath = 'C:/Users/Param/Test/' + files.filetoUpload.name;
            fs.rename(oldpath, newpath, function (err) {
                if (err) throw err;
                res.write('File uploaded and moved!');
                res.end();
            });
        });
    } else {
        res.writeHead(200, {
            'Content-Type': 'text/html'
        });
        res.write('<form action="fileUpload" method="post" enctype="multipart/form-data">');
        res.write('<input type="file" name="filetoUpload" /> <br />')
        res.write('<input type="submit" /></form>')
        return res.end();
    }
}).listen(8083);