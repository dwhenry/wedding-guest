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
    value = cell.data('value');
    cell.addClass('input');
    var input = $('<input type="text" value="' + value +   '"/>')
    cell.html(input);
    input.focus();
    // $(field).editable('http://www.example.com/save.php');
  }

  function stop_edits(target) {
    elements = target.find('input');
    elements.each(function(id, elem) {
      var parent = $($(elem).parent());
      parent.data('value', $(elem).val())
      parent.html($(elem).val());
    })
    $('.editing .input').each(function() { $(this).removeClass('input') });
    $('.editing').each(function() { $(this).removeClass('editing') });
  }

  function edit_update(target , key) {
    // event.stopPropagatxion();
    target = $(target);
    target.parent().data('.value', target.val());

    switch(key)
    {
      case 10: case 13: case 9: //tab
        remove_edit(event.target);
        parent = target.parent()
        if(parent == undefined) return;
          stop_edits(target.closest('table'));
          edit_field(parent.next());
        break;
      case 27: //escape
        remove_edit(event.target);
      default:
        return true;
    }
    return false;
  }

  function remove_edit(target){
    pending_row = false;
    $(target).html('');

  }

  function post_apocalyptic() {
    invisible_input = $('<input style="display: none/>');
    $('table.editable').after(invisible_input);
  }

  $('table tr').click(function() {
    navigate_to($(this).data('url'));
  });

  $('table.editable tfoot tr').click(function() {
    add_data_row($(this));
  });

  $('table.editable td').click(function() {
    edit_field($(this));
  });

  $('body').on('keydown', '.editing input', function(e) {
    return edit_update($(this), e.which);
  });

  $('table.editable').each(function() {
    return post_apocalyptic();
  });
});