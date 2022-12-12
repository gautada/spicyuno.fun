import {micromark} from 'https://esm.sh/micromark@3?bundle';

function closeHamburger() {
    var control = document.querySelector('#hamburger');
    control.checked=false;
}

function renderContent(uri) {
  var elements = document.getElementsByClassName('dynamic-content');
  for(var i = 0; i < elements.length; i++) {
     var eid = elements[i].id
     loadContent(eid, uri + eid);
     // console.log(elements[i].id);
  }
}
    
function loadContent(eid, uri) {
   // read text from URL location
   var request = new XMLHttpRequest();
   request.open('GET', uri, true);
   request.send(null);
   request.onreadystatechange = function () {
      if (request.readyState === 4 && request.status === 200) {
         var type = request.getResponseHeader('Content-Type');
         if (type.indexOf("text") !== 1) {
            var content =  request.responseText;
            var element = document.getElementById(eid);
            // var rendered = md.render(content);
            var rendered = micromark(content);
            element.innerHTML = rendered;
            // For debugging
            // console.log(element.innerHTML);
            // console.log(rendered);
            // console.log(content);
            // console.log(eid);
   
         }
      }
   }
   
}

renderContent("https://raw.githubusercontent.com/gautada/spicyuno.fun/main/");
