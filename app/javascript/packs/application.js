// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
import 'bootstrap'
import consumer from '../channels/consumer'



document.addEventListener("turbolinks:load", function() {

  var App_subscriptions = {};

  $('#chat-bar li').click(function(){
    const recipient_id = $(this).attr('user_id');
    $.ajax({
      url: '/conversation',
      data: {recipient_id: recipient_id},
      method: 'get'
    }).done(function(data){

      var chatBoxElement = $(data);
      addEventForChatBox(chatBoxElement);
      createConversationChannel(chatBoxElement);

      chatBoxElement.insertBefore('#chat-box-markup');
      renderListChatBox();
    })  
});

  var addEventForChatBox = function(chatBoxElement){
    
      chatBoxElement.find('.close').click(function(){
      chatBoxElement.remove();
      renderListChatBox();

    });
  }

  var renderListChatBox = function () {
    $(".chat-box").each(function (index) {
      $(this).css({ right: index * 20.5 + 16.66667+ "%" });
    });
  };

 

  var createConversationChannel = function(chatBoxElement){
  
  var conversation_id = chatBoxElement.attr('conversation_id');

  consumer.subscriptions.create({
  channel:'ConversationChannel',
  conversation_id: conversation_id
 }, {
  received: function(data) {
    console.log(consumer);
    console.log(App);
    var messages = JSON.parse(data.messages)
    console.log(messages);
    renderMessages(chatBoxElement,messages )
  }
});

}

  var renderMessages = function(chatBoxElement,messages){

    messages.forEach(function(mess, index, messages){
      var str = `<li class="message">${mess.user_id + ': ' + mess.body}<li>`;
      $(str).insertBefore(chatBoxElement.find('.message-markup'));
    })
  }

});


