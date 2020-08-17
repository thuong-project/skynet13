import consumer from "./consumer"
consumer.subscriptions.create({
  channel:'AppearanceChannel'
 }, {
  received: function(data) {
    var user = JSON.parse(data)
    if (user.online === true){
      $(userImgIdConstructor(user)).attr('class', 'online');
    };
    if (user.online === false){
      $(userImgIdConstructor(user)).attr('class', 'offline');
    };
  }
});

var userImgIdConstructor = function(user){
  return "#" + user.id + "-status";
}
