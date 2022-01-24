require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")
require("./libs/bootstrap_custom")

import $ from 'jquery';
import Tagify from '@yaireo/tagify'
import "@fortawesome/fontawesome-free/js/all";
import 'lightgallery/dist/js/lightgallery-all';

//stylesheets
import "../stylesheets/application.scss";

//components
import "./components/navbar.js";
import "./components/tts-queue.js";
import "./components/tts-timer.js";
import "./components/streamer-dashboard.js";

$(document).ready(() => {
  $('.toast').toast('show');
  const options = {
    thumbnail:true,
    animateThumb: false,
    showThumbByDefault: true,
    loadYoutubeThumbnail: true,
    youtubeThumbSize: 'default',
    loadVimeoThumbnail: true,
    vimeoThumbSize: 'thumbnail_medium',
  };
  $('#videogallery').lightGallery(options);
  $('#lightgallery').lightGallery(options);


  const tagInput = document.getElementsByClassName('js--tagify-video-urls')[0];
  if (tagInput) {
    new Tagify(tagInput, {
      originalInputValueFormat: valuesArr => valuesArr.map(item => item.value)
    }); 
  }

  $('#tts-form').submit(function(e) {
    e.preventDefault();

    $.post('/speak', {tts: $('#tts').val()}, function(data) {
      var audio = new Audio('/tts.mp3?cache='+Math.floor(Date.now() * Math.random()));
      audio.play();
    })

    return false
  })
})