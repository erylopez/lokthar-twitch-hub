$(document).ready(() => {
  $('.twitch_mod_form').on('submit', function(e) {
    e.preventDefault();
    var username = $('#twitch_username').val();

    $.post('/streamers/mods', {username: username}, function(data) {
      location.reload();
    });
  });


  $('.remove-mod').on('click', function(e) {
    e.preventDefault();

    $.ajax({
      url: '/streamers/mods/'+$(this).data('id'),
      type: 'DELETE',
      success: function(result) {
        location.reload();
      }
    });
  })
});