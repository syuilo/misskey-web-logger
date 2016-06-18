follow = true

logs = []

window.onscroll = ->
	$window = $ window
	height = $window.height!
	scroll-top = $window.scroll-top!
	scroll-left = $window.scroll-left!
	document-height = $ document .height!

	follow := height + scroll-top >= (document-height - 64px)

	if follow
		$ \#follow .add-class \enable
	else
		$ \#follow .remove-class \enable

	if scroll-left > 0
		$ 'main > views > table-view > table > thead.fixed' .css \left, -scroll-left + \px

window.onresize = ->
	fix-thead!

$.fn.child = (s) ->
	($ @ .children s).0

$ ->
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

		add-to-line-view!
		add-to-table-view!

		function add-to-line-view
			$view = $ 'main > views > line-view'
			$logs = $view.children \logs

			$log = $ "<log tabindex=0>
				<date>#{date}</date>
				<method>#{method}</method>
				<host>#{host}</host>
				<path>#{path}</path>
				<ua>#{ua}</ua>
				<ip style='background:#{color.background};color:#{color.foreground} !important;'>#{ip}</ip>
				<worker>(#{worker})</worker>
			</log>"

			$log.append-to $logs
			if ($logs.children \log .length) > 1024
				($logs.children \log)[0].remove!

		function add-to-table-view
			$view = $ 'main > views > table-view'
			$table = $view.children \table
			$table-body = $table.children \tbody
			$head = $table.children \thead
			$fixed-head = $head.clone!.add-class \fixed

			$tr = $ "<tr tabindex=0>
				<td data-column='date'><date>#{date}</date></td>
				<td data-column='method'><method>#{method}</method></td>
				<td data-column='host'><host>#{host}</host></td>
				<td data-column='path'><path>#{path}</path></td>
				<td data-column='ua'><ua>#{ua}</ua></td>
				<td data-column='ip'><ip style='background:#{color.background};color:#{color.foreground} !important;'>#{ip}</ip></td>
				<td data-column='worker'><worker>(#{worker})</worker></td>
			</tr>"

			columns = []
			$fixed-head.children \tr .children \th .each ->
				columns.push ($ @ .attr \data-column)

			sort-column columns, $tr

			$tr.append-to $table-body
			if ($table-body.children \tr .length) > 1024
				($table-body.children \tr)[0].remove!

			fix-thead!

		if follow
			scroll-bottom!

	$ \#clear .click ->
		logs := []
		$ 'main > views > line-view > logs' .empty!
		$ 'main > views > table-view > table > tbody' .empty!

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
	$table = $ 'main > views > table-view > table'
	$head = $table.children \thead
	$fixed-head = $head.clone!.add-class \fixed
	$fixed-head.prepend-to $table
	Sortable.create ($fixed-head.child \tr), {
		animation: 150ms
		chosen-class: \chosen
		on-start: ->
			$fixed-head.add-class \dragging
		on-end: ->
			$fixed-head.remove-class \dragging
		on-update: ->
			$head.children \tr .empty!
			$ths = $fixed-head.children \tr .children \th
			columns = []
			$ths.each ->
				$th = ($ @).clone!
				$th.remove-attr \style
				$head.children \tr .append $th
				columns.push $th.attr \data-column
			$table.children \tbody .children \tr .each ->
				sort-column columns, $ @
	}
	fix-thead!

function fix-thead
	scroll-left = $ window .scroll-left!

	$table = $ 'main > views > table-view > table'
	$head = $table.children 'thead:not(.fixed)'

	$fixed-head = $table.children 'thead.fixed'
	$fixed-head.children \tr .children \th .each (i, th) ->
		$source-th = $head.children \tr .children "th:nth-child(#{i + 1})"
		$th = $ th
		$th.css {
				display: \inline-block
				box-sizing: \border-box
				width: $source-th.outer-width! + \px
		}
	$fixed-head.css {
		display: \block
		position: \fixed
		'z-index': 1
		top: $ 'body > header' .outer-height! + \px
		left: -scroll-left + \px
		width: $head.outer-width! + \px
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
