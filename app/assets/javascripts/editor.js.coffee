$ ->
  text_for = (el)->
    string = ''
    $(el)
    .parents('.container')
    .find('.text_container')
    .data('text')

  $('#editor .edit a').click (event)->
    $('.cover').show()
    $('.cover form').attr('action', $(this).parent().data('url'))
    $('.cover form textarea').val text_for(this)
    event.stopPropagation() && event.preventDefault()
    false

  $('#editor a.cancel').click ->
    $('.cover').hide()
    event.stopPropagation() && event.preventDefault()
    false
