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
  }, 3000);
}

$(document).ready(() => {
  const streamer = $('.queue-data').data('streamer');

  $('.tts-replay').on('click', function(e) {
    var audio = document.getElementById('ttsAudio');
    audio.load();
    audio.play();
    playSound(audio.src);
  });

  $('.tts-mute').on('click', function(e) {
    muteSound();
    muteAction();
  });

  $('.tts-unmute').on('click', function(e) {
    unmuteSound();
    unmuteAction();
  });

  $('.tts-play').on('click', function(e) {
    e.preventDefault();
    var ttsId = $(this).data('tts-id');

    $.post('/speak', {id: ttsId}, function(data) {
      var audio = document.getElementById('ttsAudio');
      var filename = `/${data.filename}.mp3?cache=`+Math.floor(Date.now() * Math.random());

      audio.setAttribute('src', filename);
      audio.load()

      setTimeout(function(){
        audio.play();
        playSound(filename);
      }, 3000);
    });
  });

  $('.tts-skip').on('click', function(e) {
    e.preventDefault();
    var ttsId = $(this).data('tts-id');
    var el = $(this).closest('.list-group-item-action');

    $.post('/speak/reject', {id: ttsId}, function(data) {
      el.fadeOut();
    })
  })

  $('.tts-stop').on('click', function(e) {stopSound()});
  $('.tts-reload').on('click', function(e) {refreshWidget();location.reload();});


  function playSound(filename) {
    $.post('/streamers/mods/play', {id: streamer, filename: filename}, function(data) {
      console.log(data);
    });
  }

  function muteSound() {
    $.post('/streamers/mods/mute', {id: streamer}, function(data) {
      console.log(data);
    });
  }

  function unmuteSound() {
    $.post('/streamers/mods/unmute', {id: streamer}, function(data) {
      console.log(data);
    });
  }

  function stopSound() {
    $.post('/streamers/mods/stop', {id: streamer}, function(data) {
      console.log(data);
    });
  }


  function refreshWidget() {
    $.post('/streamers/mods/refresh', {id: streamer}, function(data) {
      console.log(data);
    });
  }
});


function anotherOption(data) {
  return false;
  // I had to switch to an actual audio elemento to be able to mute all sounds if needed
  var audio = new Audio(`/${data.filename}.mp3?cache=`+Math.floor(Date.now() * Math.random()));
  setTimeout(function(){
    audio.play();
  }, 3000);
}