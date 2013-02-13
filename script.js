(function() {
  var LinkData;

  LinkData = (function() {

    function LinkData(table) {
      this.table = table;
    }

    LinkData.prototype.clearTable = function() {
      return this.table.find('tbody').children('tr').remove();
    };

    LinkData.prototype.buildTable = function() {
      var _this = this;
      return $.get('/links', function(data) {
        _this.clearTable();
        return $.each(data, function(key, value) {
          return _this.buildRow(value);
        });
      });
    };

    LinkData.prototype.formatUrl = function(url) {
      return $('<a></a>').append(url).attr("href", url);
    };

    LinkData.prototype.formatTime = function(time) {
      var m;
      m = moment(time);
      return m.format("DD/MM/YYYY, HH:mm:ss");
    };

    LinkData.prototype.buildRow = function(row) {
      var tr;
      tr = $('<tr></tr>');
      tr.append($('<td></td>').append(row['channel']));
      tr.append($('<td></td>').append(row['nick']));
      tr.append($('<td></td>').append(this.formatTime(row['time'])));
      tr.append($('<td></td>').append(this.formatUrl(row['url'])));
      tr.append($('<td></td>').append(row['message']));
      return this.table.find('tbody').append(tr);
    };

    return LinkData;

  })();

  jQuery(function() {
    var ld;
    ld = new LinkData($("#content table"));
    ld.buildTable();
    return $('#refresh').click(function() {
      return ld.buildTable();
    });
  });

}).call(this);
