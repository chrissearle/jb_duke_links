class LinkData
  buildRow: (table, row) ->
    table.append '<tr>'
    table.append '<td>' + row['channel'] + '</td>'
    table.append '<td>' + row['nick'] + '</td>'
    m = moment row['time']
    
    table.append '<td>' + m.format("DD/MM/YYYY, HH:mm:ss") + '</td>'
    table.append '<td><a href="' + row['url'] + '">' + row['url'] + '</a></td>'
    table.append '<td>' + row['message'] + '</td>'
    table.append '</tr>'
  
jQuery ->
  $.get '/links', (data) ->
    $.each data, (key, value) ->
      ld = new LinkData
      ld.buildRow $("#content table"), value
