var request;
var bullets = document.getElementsByTagName("ul")[0].getElementsByTagName("li");  // Stores the li's in the tasklist ul

for (var i = 0; i < bullets.length; i++) {                                      // This for gets the li's
  var buttons = bullets[i].getElementsByTagName("a");                           // Gets the buttons of the li
  var delete_button = buttons[buttons.length-1];                                // Gets the delete button (depends on it being the first in the button list)
  var action_button = buttons[0];                                               // Gets the action button (depends on it being the first in the button list)
  
  delete_button.addEventListener("click", function(event) {                     // Declares the behavior of the delete button when you click it
    request = new XMLHttpRequest();                                             // Creates HTTP Request
    request.open(this.getAttribute("data-method"), this.getAttribute("href"));  // Opens the request, setting the method and the url
    var self = this;
    request.onreadystatechange = function () {              // Determines what is done when the readyState changes
      if (this.readyState === 4 && this.status === 200) {
        self.parentNode.remove();                           // Deletes the li from the view
      }
    };
    request.send();                                         // Sends the request
    event.preventDefault();                                 // Prevents the method's default behavior (GET)
  });
  
  action_button.addEventListener("click", function(event) { // Declares the behavior of the action button when you click it
    request = new XMLHttpRequest();                         // Creates HTTP Request
    request.open("POST", this.getAttribute("href"));        // Opens the request, setting the method and the url
    var self = this;
    request.onreadystatechange = function () {              // Determines what is done when the readyState changes
      if (this.readyState === 4 && this.status === 200) {
        console.log("DONE!");
      }
    };
    request.send();                                         // Sends the request
    event.preventDefault();                                 // Prevents the method's default behavior (GET)
  });
}