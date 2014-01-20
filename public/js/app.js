var request;
var bullets = document.getElementsByTagName("ul")[0].getElementsByTagName("li");

for (var i = 0; i < bullets.length; i++) {
  var button = bullets[i].getElementsByTagName("a")[0];
  button.addEventListener("click", function(event) {
    request = new XMLHttpRequest();
    request.open(this.getAttribute("data-method"), this.getAttribute("href"));
    var self = this;
    request.onreadystatechange = function () {
      if (this.readyState === 4 && this.status === 200) {
        self.parentNode.remove();
      }
    };
    request.send();
    event.preventDefault();
  });
}