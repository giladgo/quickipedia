CHANGE_EVENT_LIST = 'propertychange change click keyup input paste'
WM_ENDPOINT = 'https://en.wikipedia.org/w/api.php'

$(->

	makeQuery = ->
		val = textBox.val()
		if _.isEmpty(val)
			$('#result').html('')
			return
		q = encodeURIComponent(val)
		wmURL = "#{WM_ENDPOINT}?format=json&action=query&prop=extracts&exintro=&redirects&exsentences=3&titles=#{q}"
		$.ajax(wmURL, async: false, dataType: 'jsonp', crossDomain: true).done((data)->
			theKey = _.findKey(data.query.pages)*1
			console.log(data)
			if theKey > 0
				extract = data.query.pages[theKey].extract
				title   = data.query.pages[theKey].title
				$('#result').html(extract)
			else
				$('#result').html('')
		)

	textBox = $('input#query-text')
	textBox.bind(CHANGE_EVENT_LIST, _.debounce((->
		makeQuery()
	), 250))

	makeQuery()

	$('form').submit(-> false)
)