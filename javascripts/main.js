(function() {
  var CHANGE_EVENT_LIST, WM_ENDPOINT;

  CHANGE_EVENT_LIST = 'propertychange change click keyup input paste';

  WM_ENDPOINT = 'https://en.wikipedia.org/w/api.php';

  $(function() {
    var textBox;
    textBox = $('input#query-text');
    textBox.bind(CHANGE_EVENT_LIST, _.debounce((function() {
      var q, val, wmURL;
      val = textBox.val();
      if (_.isEmpty(val)) {
        return;
      }
      q = encodeURIComponent(val);
      wmURL = WM_ENDPOINT + "?format=json&action=query&prop=extracts&exintro=&explaintext=&redirects&exsentences=3&titles=" + q;
      return $.ajax(wmURL, {
        async: false,
        dataType: 'jsonp',
        crossDomain: true
      }).done(function(data) {
        var extract, theKey;
        theKey = _.findKey(data.query.pages) * 1;
        if (theKey > 0) {
          extract = data.query.pages[theKey].extract;
          extract = extract.replace('best known for', '<b>best known for</b>');
          return $('#result').html(extract);
        } else {
          return $('#result').html('');
        }
      });
    }), 250));
    return $('form').submit(function() {
      return false;
    });
  });

}).call(this);
