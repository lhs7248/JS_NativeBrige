
var mapCollection ={};




function getToken() {
    
    const messageId = "100000000";

    mapCollection[messageId]= function(token){
        console.log(token);
    };

   var param =  {"requireBack":true,"method":"customFunction","messageId":messageId,"messageBody":{}};
     var  jsonStr = JSON.stringify(param);


   window.webkit.messageHandlers.getToken.postMessage(jsonStr);


//    window.webkit.messageHandlers.getToken1.postMessage(["name","title"]);
    // window.webkit.messageHandlers.getToken1.postMessage(function(data){
        // alert(data +"mess")
    // })
}

function getTokenStr(token){

    alert(token)
    // console.log(token)

}


function customFunction(obj){
   console.log(obj);
   var dict =  JSON.parse(obj);

   const messageBody = dict["messageBody"];
   const messageId =  dict["messageId"];

   mapCollection[messageId](messageBody);

   delete mapCollection[messageId]
   

    


}

//获取token
function getQueryString(name){
//    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
//    var r = window.location.search.substr(1).match(reg);
//    if (r != null)
//        return unescape(r[2]);
    return null;
};
function showToken (token) {
    alert(token);
}
