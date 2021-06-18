var promise = new Promise(function(resolve, reject) {
	//resolve('It resolved')
    //reject('It rejected');
    throw new Error('Some error has occured')
})

promise.then(function(successMessage) {
	    //success handler function is invoked
		console.log(successMessage);
	}, function(errorMessage) {
        //error handler function is invoked
		console.log(errorMessage);
	}).catch(function(errorMessage) {
        //error handler function is invoked
         console.log(errorMessage);
     });
