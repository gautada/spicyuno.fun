import {micromark} from 'https://esm.sh/micromark@3?bundle';
          
function loadContent(uri) {
  var elements = document.getElementsByClassName('dynamic-content');
  for(var i = 0; i < elements.length; i++) {
      var eid = elements[i].id
      if (eid.endsWith(".md")) {
          fetchContent(eid, uri + eid, true);
      } else if (eid.endsWith(".html")) {
          fetchContent(eid, uri + eid, false);
      }
  }
}

function fetchContent(eid, uri, render) {
  var request = new XMLHttpRequest();
  console.log(uri);
  request.open('GET', uri, true);
  request.send(null);
  request.onreadystatechange = function () {
      if (request.readyState === 4 && request.status === 200) {
          var type = request.getResponseHeader('Content-Type');
          if (type.indexOf("text") !== 1) {
              var content =  request.responseText;
              console.log(content);
              var element = document.getElementById(eid);
              var rendered = content;
              if (render) {
                  rendered = micromark(content);
              }
              element.innerHTML = rendered;
          }
      }
  }
  
}

function closeHamburger() {
  var control = document.querySelector('#hamburger');
  control.checked=false;
}

window.onload = function(){
  var elements = document.querySelectorAll('.hamburger-close');
  elements.forEach(function(value){
    value.onclick = function() { closeHamburger(); };
  });
};

// loadContent("./");
loadContent("http://localhost:8080/");

