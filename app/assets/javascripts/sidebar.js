$(function($) {
  function navigate_to(url) {
    if(url == undefined)
      return;
    window.location.href = url;
  }

  $('#sidebar li').click(function() {
    navigate_to($(this).data('url'));
  });

  $('#sidebar li').each(function() {
    if(window.location.pathname.replace('/new', '') == $(this).data('url'))
      $(this).addClass('selected');
  })
});