follow = true

logs = []

window.onscroll = ->
	$window = $ window
	height = $window.height!
	scroll-top = $window.scroll-top!
	document-height = $ document .height!

	follow := height + scroll-top >= (document-height - 64px)

	if follow
		$ \#follow .add-class \enable
	else
		$ \#follow .remove-class \enable

window.onresize = ->
	$ '#logs > tbody' .css \padding-top ($ '#logs > thead' .outer-height!) + \px

$ ->
	$ '#logs > tbody' .css \padding-top ($ '#logs > thead' .outer-height!) + \px

	socket = io.connect!

	socket.on \info (data) ->
		$ \machine .text data.machine
		$ \pid .text data.pid
		$ \uptime .text data.uptime

	socket.on \log (data) ->
		logs.push data

		date = data.date
		method = data.method
		host = data.host
		path = data.path
		ua = data.ua
		ip = data.ip
		color = data.color
		worker = data.worker

		$table = $ \#logs
		$body = $table.children \tbody
		$head = $table.children \thead

		$tr = $ "<tr tabindex=0>
			<td data-column='date'>#{date}</td>
			<td data-column='method'>#{method}</td>
			<td data-column='host'>#{host}</td>
			<td data-column='path'>#{path}</td>
			<td data-column='ua'>#{ua}</td>
			<td data-column='ip'><ip style='background:#{color.background};color:#{color.foreground} !important;'>#{ip}</ip></td>
			<td data-column='worker'>(#{worker})</td>
		</tr>"

		columns = []
		$head.children \tr .children \th .each ->
			columns.push ($ @ .attr \data-column)

		sort-column columns, $tr

		$tr.append-to $body
		if ($body.children \tr .length) > 1024
			($body.children \tr)[0].remove!

		if follow
			scroll-bottom!

	$ \#clear .click ->
		logs := []
		$ '#logs > tbody' .empty!

	$ \#follow .click ->
		follow := !follow

		if follow
			$ \#follow .add-class \enable
			scroll-bottom!
		else
			$ \#follow .remove-class \enable

	init-fix-thead!
	update-clock!
	set-interval update-clock, 1000ms

function scroll-bottom
	scroll 0, ($ \html .outer-height!)

function sort-column(columns, $tr)
	for i from 0 to columns.length + 1
		$tr.children "td[data-column='#{columns[i]}']" .append-to $tr

function init-fix-thead
	$head = $ '#logs > thead'
	Sortable.create ($head.children \tr).0, {
		animation: 150ms
		chosen-class: \chosen
		on-start: ->
			$head.add-class \dragging
		on-end: ->
			$head.remove-class \dragging
		on-update: ->
			$ths = $head.children \tr .children \th
			columns = []
			$ths.each ->
				columns.push ($ @ .attr \data-column)
			$ \#logs .children \tbody .children \tr .each ->
				sort-column columns, $ @
	}

function update-clock
	s = (new Date!).get-seconds!
	m = (new Date!).get-minutes!
	h = (new Date!).get-hours!

	yyyymmdd = moment!.format 'YYYY/MM/DD'
	hhmmss = moment!.format 'HH:mm:ss'

	if s % 2 == 0
		hhmmss .= replace /:/g ':'
	else
		hhmmss .= replace /:/g ' '

	$clock = $ '#now'
	$clock.children \.yyyymmdd .text yyyymmdd
	$clock.children \.hhmmss .text hhmmss
