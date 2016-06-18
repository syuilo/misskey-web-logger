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

			$tr = $ "<tr tabindex=0>
				<td><date>#{date}</date></td>
				<td><method>#{method}</method></td>
				<td><host>#{host}</host></td>
				<td><path>#{path}</path></td>
				<td><ua>#{ua}</ua></td>
				<td><ip style='background:#{color.background};color:#{color.foreground} !important;'>#{ip}</ip></td>
				<td><worker>(#{worker})</worker></td>
			</tr>"

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

	update-clock!
	set-interval update-clock, 1000ms

function scroll-bottom
	scroll 0, ($ \html .outer-height!)

function fix-thead
	$table = $ 'main > views > table-view > table'
	$table.children \thead.fixed .remove!
	$head = $table.children \thead

	$fixed-head = $head.clone!.add-class \fixed
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
		width: $head.outer-width! + \px
	}

	$fixed-head.prepend-to $table

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
