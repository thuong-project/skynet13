import consumer from "./consumer"
 

consumer.subscriptions.create({
  channel:'AppearanceChannel'
 }, {
  received: function(data) {
    var user = data;
    if (user.online === true){
      statusElement(user).attr('class','icon-status online');
      
    };
    if (user.online === false){
      statusElement(user).attr('class','icon-status offline');
    };
  },
});

function statusElement(user){
  return $(`[user_id="${user.id}"]`).find('.icon-status');
}


