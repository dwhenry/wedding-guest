$ ->
  navigating = false
  navigate_to = (url)->
    return if navigating
    navigating = true
    return if url == undefined
    window.location.href = url

  url = (el)->
    $(el).data('url')

  match = (el)->
    $(el).data('match') || '(/\\d+(/[^/]*|)|)$'

  $('#sidebar li').click ->
    navigate_to url(this)

  $('#sidebar li').each ->

    link = $(this).find('> a')
    if link.length > 0
      $(this).data('url', link.attr('href'))
      link.replaceWith link.text()

    pattern = new RegExp url(this) + match(this)

    if(window.location.pathname.match(pattern))
      $(this).addClass('selected')
