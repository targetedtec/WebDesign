var promise = new Promise(function(resolve, reject) {
    const x = "hello";
    const y = "hello"
    if(x === y) {
        resolve();
    } else {
        reject();
    }
    });
    
    promise.
        then(function () {
            console.log('Success, Awesome');
        }).
        catch(function () {
            console.log('Some error has occured');
        });
    