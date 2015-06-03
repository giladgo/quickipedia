CHANGE_EVENT_LIST = 'propertychange change click keyup input paste'
WM_ENDPOINT = 'https://en.wikipedia.org/w/api.php'

$(->
	textBox = $('input#query-text')
	textBox.bind(CHANGE_EVENT_LIST, _.debounce((->
		val = textBox.val()
		return if _.isEmpty(val)
		q = encodeURIComponent(val)
		wmURL = "#{WM_ENDPOINT}?format=json&action=query&prop=extracts&exintro=&explaintext=&redirects&exsentences=3&titles=#{q}"
		$.ajax(wmURL, async: false, dataType: 'jsonp', crossDomain: true).done((data)->
			theKey = _.findKey(data.query.pages)*1
			if theKey > 0
				extract = data.query.pages[theKey].extract
				extract = extract.replace('best known for', '<b>best known for</b>')
				$('#result').html(extract)
			else
				$('#result').html('')
		)
	), 250))

	$('form').submit(-> false)
)