// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
window.$ = $;
import "bootstrap";

import consumer from "../channels/consumer";
var moment = require("moment-timezone");

function formatDateTime(date) {
  return moment(date).utcOffset("+07:00").locale("en").calendar();
}

document.addEventListener("turbolinks:load", function () {
  $("#chat-bar li").click(function () {
    const recipient_id = $(this).attr("user_id");

    if (checkChatExist(recipient_id)) return;

    $.ajax({
      url: "/conversation",
      data: { recipient_id: recipient_id },
      method: "get",
    }).done(function (data) {
      var chatBoxElement = $(data);
      addEventForChatBox(chatBoxElement);
      chatBoxElement.insertBefore("#chat-box-markup");
      renderListChatBox();
    });

    // function support
    function renderListChatBox() {
      $(".chat-box").each(function (index) {
        $(this).css({ right: index * 254 + 200 });
      });
    }

    function renderMessages(chatBoxElement, messages) {
      messages.forEach(function (mess, index, messages) {
        var partner_id = chatBoxElement.attr("user_id");
        var str = "";
        var timeStr = formatDateTime(mess.created_at);

        if (mess.user_id == partner_id)
          str = `<li class="message"><span class="partner">${mess.body}</span>
                      <span class="time">${timeStr}</span>    
                </li>`;
        else
          str = `<li class="message"><span class="current_user">${mess.body}</span>
                      <span class="time">${timeStr}</span>
                </li>`;

        $(str).insertBefore(chatBoxElement.find(".message-markup"));
      });
      scrollListMess(chatBoxElement);
    }

    function scrollListMess(chatBoxElement) {
      var ul = chatBoxElement.find(".list-messages");
      var li = ul.find("li");
      var li_height = li.innerHeight();
      var num_li = li.length;
      console.log("num_li", num_li);
      console.log(li_height);
      ul.scrollTop(li_height * num_li);
    }

    function addEventForChatBox(chatBoxElement) {
      var conversation_id = chatBoxElement.attr("conversation_id");
      createConversationChannel(chatBoxElement, conversation_id);
      sendMessageListenner(chatBoxElement);
      isTypingListenner(chatBoxElement);

      // close chatbox and unsubcription
      chatBoxElement.find(".close").click(function () {
        var indentifierObj = {
          channel: "ConversationChannel",
          conversation_id: conversation_id,
        };
        removeSubcription(indentifierObj);

        chatBoxElement.remove();
        renderListChatBox();
      });

      //support function
      function createConversationChannel(chatBoxElement, conversation_id) {
        var sub = consumer.subscriptions.create(
          {
            channel: "ConversationChannel",
            conversation_id: conversation_id,
          },
          {
            received: function (payload) {
              console.log("payload received: ", payload);

              var data = payload.data;
              if (data.type == "new_mess") {
                var new_mess = JSON.parse(data.content);
                console.log("new mess :>> ", new_mess);
                $(chatBoxElement.find(".typing")).remove();
                renderMessages(chatBoxElement, new_mess);
              } else if (data.type == "typing") {
                renderTyping(chatBoxElement, data);
              } else if (data.type == "all_mess") {
                var partner = chatBoxElement.attr("user_id");
                if (data.to_user == partner) return;
                var all_mess = JSON.parse(data.content);
                console.log("all mess :>> ", all_mess);
                renderMessages(chatBoxElement, all_mess);
              }
            },
          }
        );
        console.log(`create conversation channel:`, sub);
      }

      function renderTyping(chatBoxElement, data) {
        var sender_id = chatBoxElement.attr("user_id");
        var sender = JSON.parse(data.sender);
        console.log("sender typing :>> ", sender);
        console.log(sender_id, sender.id, sender.id == sender.id);
        if (sender_id == sender.id.toString()) {
          if (data.status == "focus") {
            console.log("redering typing...");
            var html = `<li class="typing">${sender.name} is Typing...</li>`;
            $(html).insertBefore(chatBoxElement.find(".message-markup"));
            scrollListMess(chatBoxElement);
          } else {
            console.log("remove typing...");
            chatBoxElement.find(".typing").remove();
            scrollListMess(chatBoxElement);
          }
        }
      }

      function removeSubcription(indentifierObj) {
        var sub = getSubscription(indentifierObj);
        sub.unsubscribe();
        console.log("remove subcriptions :>> ", consumer.subscriptions);
      }

      function sendMessageListenner(chatBoxElement) {
        var sendMessButton = chatBoxElement.find(".send-message")[0];
        const inputMess = chatBoxElement.find(
          'textarea[name="message-will-send"]'
        )[0];
        $(sendMessButton).click(function () {
          const mess = $(inputMess).val();
          const conversation_id = chatBoxElement.attr("conversation_id");
          var sub = getSubscription({
            channel: "ConversationChannel",
            conversation_id: conversation_id,
          });

          var payload = { type: "new_mess", message: mess };
          sub.send(payload);
          console.log("payload sent :>> ", payload);
          $(inputMess).val("");
        });

        // enter key

        $(inputMess).keydown(function (event) {
          var keycode = event.keyCode ? event.keyCode : event.which;
          if (event.ctrlKey && event.keyCode == 13) {
            // Ctrl-Enter pressed
            console.log("ctrl+enter");
            var oldvar = $(inputMess).val();
            $(inputMess).val(oldvar + "\r\n");
          } else if (keycode == "13") {
            event.preventDefault();
            $(sendMessButton).click();
          }
        });

        //
      }

      function isTypingListenner(chatBoxElement) {
        var inputMess = chatBoxElement.find(
          'textarea[name="message-will-send"]'
        )[0];
        $(inputMess).focus(function () {
          const conversation_id = chatBoxElement.attr("conversation_id");
          var sub = getSubscription({
            channel: "ConversationChannel",
            conversation_id: conversation_id,
          });

          var payload = { type: "typing", status: "focus" };
          sub.send(payload);
          console.log("payload sent :>> ", payload);
        });

        $(inputMess).blur(function () {
          const conversation_id = chatBoxElement.attr("conversation_id");
          var sub = getSubscription({
            channel: "ConversationChannel",
            conversation_id: conversation_id,
          });

          var payload = { type: "typing", status: "blur" };
          sub.send(payload);
          console.log("payload sent :>> ", payload);
        });
      }
    }
  });

  function getSubscription(indentifierObj) {
    const str = JSON.stringify(indentifierObj);
    var subs = consumer.subscriptions.findAll(str);
    return subs.length == 0 ? null : subs[0];
  }
  function checkSubExist(indentifierObj) {
    var sub = getSubscription(indentifierObj);
    return sub == null ? false : true;
  }
  function checkChatExist(partner_id) {
    var arr = $(`.chat-box[user_id="${partner_id}"]`);
    return arr.length > 0 ? true : false;
  }

  function cancel(element) {
    $(element).off();
    $(element).one("click",(function () {
      let current = $(this).attr("current-target");
      let incoming = $(this).attr("incoming-target");
      let cancel = `<button class="btn btn-danger" 
                              current-target="${current}"
                              incoming-target="${incoming}"
                              name="cancel"
                      >Cancel</button>`;

      let cancelE = $(cancel);
      $(cancelE).click(function () {
        $(incoming).remove();
        $(current).show();
        $(this).remove();
      });

      console.log(current);
      $(current).hide();
      $(cancelE).insertAfter($(current));
    }));
  }
  cancel("[name='edit']");

  function observerCallback(mutationList, observer) {
    mutationList.forEach((mutation) => {
      switch (mutation.type) {
        case "childList":
          /* One or more children have been added to and/or removed
             from the tree.
             (See mutation.addedNodes and mutation.removedNodes.) */
            console.log("modify tree");
            cancel("[name='edit']");
          break;
        case "attributes":
          /* An attribute value changed on the element in
             mutation.target. 
             The attribute name is in mutation.attributeName, and 
             its previous value is in mutation.oldValue. */
          break;
      }
    });
  }

  const targetNode = document.body;
  const observerOptions = {
    childList: true,
    //attributes: true,

    // Omit (or set to false) to observe only changes to the parent node
    subtree: true,
  };

  const observer = new MutationObserver(observerCallback);
  observer.observe(targetNode, observerOptions);
});
