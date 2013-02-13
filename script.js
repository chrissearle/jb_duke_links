(function() {
  var LinkData;

  LinkData = (function() {

    function LinkData() {}

    LinkData.prototype.buildRow = function(table, row) {
      var m;
      table.append('<tr>');
      table.append('<td>' + row['channel'] + '</td>');
      table.append('<td>' + row['nick'] + '</td>');
      m = moment(row['time']);
      table.append('<td>' + m.format("DD/MM/YYYY, HH:mm:ss") + '</td>');
      table.append('<td><a href="' + row['url'] + '">' + row['url'] + '</a></td>');
      table.append('<td>' + row['message'] + '</td>');
      return table.append('</tr>');
    };

    return LinkData;

  })();

  jQuery(function() {
    return $.get('/links', function(data) {
      return $.each(data, function(key, value) {
        var ld;
        ld = new LinkData;
        return ld.buildRow($("#content table"), value);
      });
    });
  });

}).call(this);
