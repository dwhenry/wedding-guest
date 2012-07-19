$(function($) {
  var pending_row = false;

  function navigate_to(url) {
    if(url == undefined) return;
    window.location.href = url;
  }

  function add_data_row(location) {
    if(pending_row) return
    var selector = $(location.data('table') + ' .new_row');
    if(selector == undefined) return;
    pending_row = true;
    new_row = $("<tr>" + selector.html() + "</tr>");
    $(location.data('table')).append(new_row);
    initialise_row(new_row);
  }

  function initialise_row(row) {
    var first_field_edited = false;
    row.children('td').each(function() {
      var cell = $(this)
      if(cell.data('value') != undefined )
        cell.html(cell.data('value'))
      else if(!first_field_edited) {
        first_field_edited = true;
        edit_field(cell);
      }
    })

  }

  function edit_field(cell) {
    cell = $(cell);
    if(cell.data('field') == undefined) return;
    $('.editing').removeClass('editing');
    cell.parent().addClass('editing');
    value = cell.text();
    var input = $('<input type="' + value +   '"/>')
    cell.html(input);
      input.focus();
    // $(field).editable('http://www.example.com/save.php');
  }

  function edit_update(target , key) {
    // event.stopPropagatxion();
    target = $(target);
    target.parent().data('.value', target.val());

    switch(key)
    {
      case 10:
      case 13:
      case 9: //tab
        remove_edit(event.target);
        parent = target.parent()
        if(parent == undefined) return;
          edit_field(parent.next());
        break;
      case 27: //escape
        remove_edit(event.target);
      else
        console.log('bitch')
        //#event.target);

    }
  }

  function remove_edit(target){
    return  $(target);

  }

  function post_apocalyptic() {
    invisible_input = $('<input style="display: none/>');
    $('table.editable').after(invisible_input);
  }

  $('table tr').click(function() {
    navigate_to($(this).data('url'));
  });

  $('table.editable tr').click(function() {
    add_data_row($(this));
  });

  $('table.editable td').click(function() {
    edit_field($(this));
  });

  $('table.editable').on('keydown', 'input', function() {
    edit_update($(this), this.which);
  });

  $('table.editable').each(function() {
    return post_apocalyptic();
  });
});