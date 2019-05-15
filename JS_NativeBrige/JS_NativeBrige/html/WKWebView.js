
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


  var parm = 'JSExport Toast';
  window.webkit.messageHandlers.openBrowser.postMessage(parm);

  console.log(locationMessage);
}
function jsExportToastArray(){

  var parm = ["name","age","sex"];
  window.webkit.messageHandlers.openBrowser.postMessage(parm);
}
function jsExportToastDict(){

  var parm =  {"name":"lili","age":18,"sex":'boy'};

  window.webkit.messageHandlers.openBrowser.postMessage(parm);
}
// 显示 toast 弹窗
function jsExportLocation(){
    const messageId = "100000000";
    mapCollection[messageId]= function(result){
      document.getElementById("location_text").innerHTML = result;
    };

   var param =  {"requireBack":true,"method":"customFunction","messageId":messageId,"messageBody":{}};

   window.webkit.messageHandlers.getToken.postMessage(param);
}


function testJsExportToastStr(){
    var startTimes = +new Date();
  for (var i = 0; i < 1000; i++) {

   window.webkit.messageHandlers.getToken.postMessage('ald://showToastTest?message="点我试试看"');
  }

  var endTimes = +new Date();
  document.getElementById("testJSCoreCostTime").innerHTML = endTimes - startTimes;
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

function WKWebViewReadFile() {
  
  if (this.files && this.files[0]) {
    
    var FR= new FileReader();
    
    FR.addEventListener("load", function(e) {
      document.getElementById("img").src       = e.target.result;
      document.getElementById("b64").innerHTML = e.target.result;

      var param =  {"requireBack":false,"messageBody":{'image':e.target.result}};

      window.webkit.messageHandlers.openBrowser.postMessage(param);
    }); 
    
    FR.readAsDataURL( this.files[0] );
  }
  
}

document.getElementById("WKWebViewInp").addEventListener("change", WKWebViewReadFile);



function webViewReadFile() {
  
  if (this.files && this.files[0]) {
    
    var FR= new FileReader();
    
    FR.addEventListener("load", function(e) {
      document.getElementById("img").src       = e.target.result;
      document.getElementById("b64").innerHTML = e.target.result;

      var param =  {"requireBack":false,"messageBody":{'image':e.target.result}};

      NativeFunction.showDict(param)
    }); 
    
    FR.readAsDataURL( this.files[0] );
  }
  
}

document.getElementById("WKWebViewInp").addEventListener("change", webViewReadFile);
