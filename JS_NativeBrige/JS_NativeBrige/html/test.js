
var mapCollection ={};

function getToken() {
    
    const messageId = "100000000";
    mapCollection[messageId]= function(token){
        console.log(token);
    };

   var param =  {"requireBack":true,"method":"customFunction","messageId":messageId,"messageBody":{}};
     var  jsonStr = JSON.stringify(param);


   //window.webkit.messageHandlers.getToken.postMessage(jsonStr);

   window.webkit.messageHandlers.openBrowser.postMessage(jsonStr);
}



function customFunction(obj){
   console.log(obj);
   var dict =  JSON.parse(obj);

   const messageBody = dict["messageBody"];
   const messageId =  dict["messageId"];

   mapCollection[messageId](messageBody);

   delete mapCollection[messageId]



}
