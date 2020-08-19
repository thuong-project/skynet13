import consumer from "./consumer"

consumer.subscriptions.create({
  channel:'AppearanceChannel'
 }, {
  received: function(data) {
    var user = JSON.parse(data)
    if (user.online === true){
      $(element({user_id: user.id, cssClass: '.icon-status'})).attr('class','icon-status online');
      
    };
    if (user.online === false){
      $(element({user_id: user.id, cssClass: '.icon-status'})).attr('class','icon-status offline');
    };
  }
});

var element = function(e){
  return ".user-" + e.user_id + ' ' + e.cssClass;
}
