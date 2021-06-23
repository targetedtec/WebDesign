async function myDisplay() {
    let myPromise = new Promise(function(myResolve, myReject) {
      setTimeout(function() { myResolve("Awesome !!"); }, 3000);
    });
    console.log(await myPromise);
}

//myDisplay();
myDisplay().then(function(){
    console.log("Executed Finally");
});
//console.log("Executed!!");