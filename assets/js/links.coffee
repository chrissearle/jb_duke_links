class LinkData
  constructor: (table) ->
    @table = table
    
  clearTable: ->
    @table.find('tbody').children('tr').remove()
    
  buildTable: ->
    $.get '/links.json', (data) =>
      this.clearTable()
      $.each data, (key, value) =>
        this.buildRow(value)
      this.shortenText()
        
  formatUrl: (url) ->
    $('<a rel="nofollow" data-pos="right" data-length="50" class="shorten"></a>').text(url).attr("href", url)
    
  formatTime: (time) ->
    m = moment time
    m.format("DD/MM/YYYY, HH:mm:ss").replace(" ", "&nbsp;")
    
  buildRow: (row) ->
    tr = $('<tr></tr>')

    tr.append $('<td></td>').append(row['channel'])
    tr.append $('<td></td>').append(row['nick'])
    tr.append $('<td></td>').append(this.formatTime(row['time']))
    tr.append $('<td></td>').append(this.formatUrl(row['url']))
    tr.append $('<td data-pos="left" data-length="100" class="shorten"></td>').text(row['message'])

    @table.find('tbody').append tr
  
  shortenText: ->
    @table.find('tbody').find('.shorten').each ->
      maxLength = $(this).data('length')
      if $(this).text().length > maxLength
        origText = $(this).text()
        $(this).html(origText.substring(0, maxLength) + "&hellip;")
        $(this).popover({content: origText, trigger: 'hover', html: true, placement: $(this).data('pos'), title: "Full Text"})
  
jQuery ->
  ld = new LinkData $("#content table")
  ld.buildTable()
  $('#refresh').click ->
    ld.buildTable()
