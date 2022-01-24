import consumer from "./consumer"

$(document).ready(() => {
  const streamer = $('#widget_root').data('streamer');

  consumer.subscriptions.create({channel: "QuickVoteCounterChannel", streamer: streamer}, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log("Connected!")
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },
  
    received(data) {
      document.getElementById("quick-votes-counter").innerHTML = data.counter;
    }
  });
});
