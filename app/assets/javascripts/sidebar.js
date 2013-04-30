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
    var pattern = new RegExp($(this).data('url') + '(/\\d+(/[^/]*|)|)$');
    // console.log(pattern);
    if(window.location.pathname.match(pattern))
      $(this).addClass('selected');
  })
});