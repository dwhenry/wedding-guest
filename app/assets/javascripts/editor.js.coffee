$ ->
  text_for = (el)->
    string = ''
    data = $(el).parents('.container').find('p')
    data.each (i, str)->
      string += "\n" + $(str).text().trim()
    string.trim()

  $('.edit .img a').click (event)->
    $('.cover').show()
    $('.cover form').attr('action', $(this).parent().data('url'))
    $('.cover form textarea').val text_for(this)
    event.stopPropagation() && event.preventDefault()
    false

  $('#editor a').click ->
    $('.cover').hide()
    event.stopPropagation() && event.preventDefault()
    false
