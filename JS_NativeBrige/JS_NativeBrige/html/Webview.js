
var mapCollection ={};


function protocolURL(str){
  let iframe = document.createElement('IFRAME');
  iframe.setAttribute('src',str);
  iframe.setAttribute('style','display:none');
  document.documentElement.appendChild(iframe);
  iframe.parentNode.removeChild(iframe);
  iframe = null;
}
function protocol(){
  protocolURL('ald://showToast?message="点我试试看"');

}

function testProtocolURL(){
  var startTimes = +new Date();
  for (var i = 0; i < 1000; i++) {
    protocolURL('ald://showToastTest?message="点我试试看"');
  }

  var endTimes = +new Date();
  document.getElementById("testProtocolCostTime").innerHTML = (endTimes - startTimes);

}
// 显示 toast 弹窗
function jsExportToastStr(){

   var locationMessage = NativeFunction.showTost('JSExport Toast');

}
function testJsExportToastStr(){
    var startTimes = +new Date();
  for (var i = 0; i < 1000; i++) {
    NativeFunction.showTestTost("JSExport Test Toast");
  }

  var endTimes = +new Date();
  document.getElementById("testJSCoreCostTime").innerHTML = endTimes - startTimes;
}

function jsExportToastArray(){

  var array = ["name","age","sex"]
   var locationMessage = NativeFunction.showArray(array);
}
function jsExportToastDict(){

  var dict = {"name":"lili","age":18,"sex":'boy'}

   var locationMessage = NativeFunction.showDict(dict);
}
// 显示 toast 弹窗
function jsExportLocation(){

  var locationMessage = NativeFunction.getCurrentLocation();

  document.getElementById("location_text").innerHTML = locationMessage;
   console.log(locationMessage);
}



function postMessage(){

  for (var i = 0; i < 10000; i++) {

    const messageId = "10" + i;

    mapCollection[messageId]= function(token){
        console.log(token);
    };
   var param =  {"requireBack":true,"method":"customFunction","messageId":messageId,"messageBody":{'key':'this is Post Test'}};

   window.webkit.messageHandlers.openBrowser.postMessage(param);
  }

}
function promptMessage(){

  var name=prompt("Please enter your name","")
}


function customFunction(obj){
   console.log(obj);
   var dict =  JSON.parse(obj);

   const messageBody = dict["messageBody"];
   const messageId =  dict["messageId"];

   mapCollection[messageId](messageBody);

   delete mapCollection[messageId]
}

function readFile() {
  
  if (this.files && this.files[0]) {
    
    var FR= new FileReader();
    
    FR.addEventListener("load", function(e) {
      document.getElementById("img").src       = e.target.result;
      // document.getElementById("b64").innerHTML = e.target.result;

      var param =  {"requireBack":false,'image':e.target.result};
      NativeFunction.showBigData(param);
    }); 
    
    FR.readAsDataURL( this.files[0] );
  }
  
}

document.getElementById("webViewInput").addEventListener("change", readFile);

