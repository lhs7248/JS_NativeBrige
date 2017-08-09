
var mapCollection ={};




function getToken() {
    
    const id = "100000000";

    mapCollection[id]= function(token){
        console.log(token);
    };

   var param =  {"requireBack":"false","method":"customFunction","messageId":id,"messageBody":{}};
     var  jsonStr = JSON(param);

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

   const param = dict["param"];
   const id =  dict["id"];

   mapCollection[id](param);

   delete mapCollection[id]
   

    


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
