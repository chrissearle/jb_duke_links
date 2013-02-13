class LinkData
  constructor: (table) ->
    @table = table
    
  clearTable: ->
    @table.find('tbody').children('tr').remove()
    
  buildTable: ->
    $.get '/links', (data) =>
      this.clearTable()
      $.each data, (key, value) =>
        this.buildRow(value)
        
  formatUrl: (url) ->
    $('<a></a>').append(url).attr("href", url)
    
  formatTime: (time) ->
    m = moment time
    m.format("DD/MM/YYYY, HH:mm:ss")
    
  buildRow: (row) ->
    tr = $('<tr></tr>')

    tr.append $('<td></td>').append(row['channel'])
    tr.append $('<td></td>').append(row['nick'])
    tr.append $('<td></td>').append(this.formatTime(row['time']))
    tr.append $('<td></td>').append(this.formatUrl(row['url']))
    tr.append $('<td></td>').append(row['message'])

    @table.find('tbody').append tr
  
jQuery ->
  ld = new LinkData $("#content table")
  ld.buildTable()
  $('#refresh').click ->
    ld.buildTable()
