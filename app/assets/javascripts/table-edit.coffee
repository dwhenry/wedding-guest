static = $(this)
@rowEditor = null;

class RowEditor
  constructor: (@row) ->
    @row.addClass('editing')
    @edit @firstCell()
    @fieldsAdded = false

  firstCell: ->
    @row.children('td:visible').first()

  nextCell: (fnt) ->
    @getCell('next', fnt)

  prevCell: (fnt) ->
    @getCell('prev', fnt)

  getCell: (direction, fnt) ->
    cell = @cellEditor.cell[direction]()
    while cell.length > 0 && cell.data('field') == undefined
      cell = cell[direction]()
    if cell.data('field') == undefined
      @finalize()
    else
      fnt.call(this, cell)

  finalize: ->
    if @fieldsAdded || !@pending()
      @stop()
      saver = new RowSaver(@row)
      saver.save()
    else
      @stop(true)

  move: (cell) ->
    @edit cell

  edit: (cell) ->
    @stopCellEdit()
    @cellEditor = Editor.build(cell);
    true

  stop: (cancel) ->
    @stopCellEdit()
    @row.removeClass('editing')
    static.rowEditor = null
    if cancel
      @row.remove()

  pending: ->
    @row.data('id') == undefined

  processKey: (event) ->
    switch event.which
      when 10, 13 then @nextCell(@edit)
      when 9
        if event.shiftKey
          @prevCell(@edit)
        else
          @nextCell(@edit)
      when 27
        @stop(true)
      else
        return true

    false

  stopCellEdit: ->
    if @cellEditor
      @fieldsAdded = true if @cellEditor.stop()
      @cellEditor = null

class RowSaver
  _row = null;
  constructor: (@row) ->
    _row = @row

  pending: ->
    @row.data('id') == undefined

  dataHash: ->
    data = {};
    @row.children('td').each ->
      unless $(this).data('field') == undefined
        data[$(this).data('field')] = $(this).data('value')
    data

  save: ->
    if @pending()
      @saveRecord()
    else
      @updateRecord()

  saveRecord: ->
    $.ajax({
      url: _row.data('edit-url'),
      data: {guest: @dataHash()},
      type: 'POST',
      success: @saveSuccess
    });

  updateRecord: ->
    $.ajax({
      url: _row.data('edit-url'),
      data: {guest: @dataHash()},
      type: 'PUT',
      success: @saveSuccess
    });

  saveSuccess: (response) ->
    _row.data('id', response['id'])
    _row.data('edit-url', response['url'])
    if response['errors'] == ''
      if _row.parent().find('.new_row')
        builder = new RowBuilder('.guests')
        static.rowEditor = new RowEditor(builder.row)
    else
      alert(response['errors'])

class Editor
  @build: (cell) =>
    switch cell.data('type')
      when undefined
        new CellEditor(cell)
      when 'select'
        new CellSelectEditor(cell)

  constructor: (@cell) ->
    @cell.addClass('input')
    @cell.html(@inputElement())
    @inputElement().focus()

  width: ->
    @cell.width() - 5 + 'px'

  cellValue: (val) ->
    if val != undefined
      return @cell.data('value', val)

    if @cell.data('value') == undefined
      ''
    else
      @cell.data('value')

  prefix: ->
    if @cell.data('prefix') == undefined
      ''
    else
      ' ' + @cell.data('prefix')

  stop: ->
    value = @inputElement().val()
    @cellValue value
    @cell.html @cellValue() + @prefix()
    @cell.removeClass('input')
    value.trim() != ''

class CellEditor extends Editor
  inputElement: ->
    @input ||= $('<input type="text" value="' + @cellValue() +   '" style="width: ' + @width() + '"" />');

class CellSelectEditor extends Editor
  inputElement: ->
    @input ||= @buildInput()

  buildInput: ->
    input = $('<select style="width: ' + @width() + '"" />');
    input.append(@build_option_for(value)) for value in ['Pending', 'Confirmed', 'Rejected']
    input

  build_option_for: (value) ->
    if value == @cellValue()
      $('<option value="' + value + '" selected="selected">' + value + '</option>')
    else
      $('<option value="' + value + '">' + value + '</option>')
class RowBuilder
  constructor: (@tableName) ->
    @copy()
    @setup()

  copy: ->
    selector = $(@tableName + ' .new_row');
    return if selector == undefined
    @row = $("<tr>" + selector.html() + "</tr>");
    $(@tableName).append(@row);

  setup: ->
    return unless @row
    @row.children('td').each ->
      cell = $(this)
      if(cell.data('value') != undefined )
        cell.html(cell.data('value'))

$ ->
  ($ 'body').click ->
    if static.rowEditor
      static.rowEditor.finalize()

  ($ 'table.editable tfoot tr').click ->
    if static.rowEditor
      return if static.rowEditor.pending()
      static.rowEditor.stop()
    if $(this).data('table')
      builder = new RowBuilder($(this).data('table'))
      static.rowEditor = new RowEditor(builder.row)
    false


  ($ 'table.editable tbody').on 'click', 'td', ->
    static.rowEditor.stop() if static.rowEditor
    static.rowEditor = new RowEditor($(this).parent())
    static.rowEditor.move($(this))
    false

  ($ 'table.editable').on 'keydown', '.editing input', (event) ->
    static.rowEditor.processKey(event)

  ($ 'table.editable').each ->
    $(this).after($('<input style="display: none/>'))

