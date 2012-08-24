$(function(){
  function correct_background() {
    var min_height = $('#screen').height() +
                     parseInt($('#screen').css('margin-top')) +
                     parseInt($('#screen').css('margin-bottom'));
    if($(window).height() > min_height)
      $('#cover').css({bottom: '0px'});
    else
      $('#cover').css({bottom: 'auto'});
  }

  $(window).resize(correct_background);

  correct_background();
});
