$ ->
  $('#add_address').click (event)->
    form = $($(this).closest('form'))
    $.post form.url, form.serialize(), (data)->
      $('address').last().after(data)
      form.find("input[type=text], textarea").val("")

    event.preventDefault()

  $('.delete-address').click (event)->
    address = $($(this).closest('.address'))
    $.ajax
      url: address.data('url'),
      type: 'DELETE'
    .success ->
      address.remove()
    .error ->
      alert 'Error deleting address'
    event.preventDefault()
