var TestHelper = {}
TestHelper.Keyboard ={
  down: function(element, inputStream) {
    var i;
    var l = inputStream.length;
    for (i = 0 ; i < l ; i++)
    {
      e = $.Event('keydown');
      e.which = inputStream.charCodeAt(i);
      element.trigger(e);
      element.val(element.val() + inputStream.charAt(i))
    }
  }
}