$(function($) {
  var pending_row = false;

  function navigate_to(url) {
    if(url == undefined) return;
    window.location.href = url;
  }

  $('table tr').click(function() {
    navigate_to($(this).data('url'));
  });
});