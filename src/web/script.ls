follow = true

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

$ ->
	socket = io.connect!

	socket.on \info (data) ->
		$ \machine .text data.machine
		$ \pid .text data.pid
		$ \uptime .text data.uptime

	socket.on \log (data) ->
		date = data.date
		method = data.method
		host = data.host
		path = data.path
		ua = data.ua
		ip = data.ip
		color = data.color
		worker = data.worker

		$log = $ "<log>
			<date>#{date}</date>
			<method>#{method}</method>
			<host>#{host}</host>
			<path>#{path}</path>
			<ua>#{ua}</ua>
			<ip style='background:#{color.background};color:#{color.foreground};'>#{ip}</ip>
			<worker>(#{worker})</worker>
		</log>"

		$log.append-to $ \logs
		if ($ \logs .children \log .length) > 1024
			($ \logs .children \log)[0].remove!

		if follow
			scroll-bottom!

	$ \#clear .click ->
		$ \logs .empty!

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

function update-clock
	s = (new Date!).get-seconds!
	m = (new Date!).get-minutes!
	h = (new Date!).get-hours!
	yyyymmdd = moment!.format 'YYYY/MM/DD'
	yyyymmdd = "<span class='yyyymmdd'>#yyyymmdd</span>"
	hhmmss = moment!.format 'HH:mm:ss'
	hhmmss = "<span class='hhmmss'>#hhmmss</span>"
	if s % 2 == 0
		hhmmss .= replace /:/g '<span style=\'visibility:visible\'>:</span>'
	else
		hhmmss .= replace /:/g '<span style=\'visibility:hidden\'>:</span>'
	clock = $ '#now'
	clock.html "#yyyymmdd#hhmmss"
