import consumer from "./consumer"

function stopAction() {
  var audio = document.getElementById('ttsAudio');
  audio.pause();
}

function muteAction() {
  var audio = document.getElementById('ttsAudio');
  audio.volume = 0;
  $('.tts-mute').addClass('d-none');
  $('.tts-unmute').removeClass('d-none');
}

function unmuteAction() {
  var audio = document.getElementById('ttsAudio');
  audio.volume = 1;
  $('.tts-mute').removeClass('d-none');
  $('.tts-unmute').addClass('d-none');
}

function playAction(filename) {
  var audio = document.getElementById('ttsAudio');

  audio.setAttribute('src', filename);
  audio.load()

  setTimeout(function(){
    audio.play();
    console.log('play performed');
  }, 3000);
}

$(document).ready(() => {
  const streamer = $('#widget_root').data('streamer');

  consumer.subscriptions.create({channel: "TtsWidgetChannel", streamer: streamer}, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log("Connected!")
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      switch(data.action) {
        case 'play':
          this.play(data);
          break;
        case 'mute':
          this.mute(data);
          break;
        case 'unmute':
          this.unmute(data);
          break;
        case 'refresh':
          this.refresh();
          break;
        case 'stop':
          this.stop();
          break;
        default:
          console.log("no action performed");
      }
    },

    play: function(data) {
      console.log('play...');
      playAction(data.filename);
      return this.perform('play');
    },

    mute: function() {
      console.log('mute performed');
      muteAction();
      return this.perform('mute');
    },

    unmute: function() {
      console.log('unmute performed');
      unmuteAction();
      return this.perform('unmute');
    },

    stop: function() {
      stopAction();
      console.log('stop action performed')
    },

    refresh: function() {
      location.reload();
      return this.perform('refresh');
    }
  });
})
