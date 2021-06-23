
let myPromise = new Promise(function(myResolve, myReject) {
  console.log("Pr0mises called");
  setTimeout(function() { 
    console.log("Promises reolved")
    myResolve("Promise Consumer called"); 
  }, 3000);
});

myPromise.then(function(value) {
  console.log( value);
});
