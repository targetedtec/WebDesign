var events = require('events').EventEmitter;
var ee = new events(); 
ee.items = [1, 2, 3, 4, 5, 6, 7];
ee.on("changedItem", function () {
    console.log("event has occured"); 
    console.log("index:" + this.lastIndexChanged + "value: "	+this.items[this.lastIndexChanged]);
    
});
function setItem(index, value) {
    ee.items[index] = value;
    ee.lastIndexChanged = index; 
    ee.emit("changedItem");
}
setItem(3, "Hello World!");
