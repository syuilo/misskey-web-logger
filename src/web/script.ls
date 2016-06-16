$ ->
	socket = io.connect!

	socket.on \log (data) ->
		date = data.date
		method = data.method
		host = data.host
		path = data.path
		ua = data.ua
		ip = data.ip
		color = data.color

		if can-scroll!

			$log = $ "<log tabindex=0>
				<date>#{date}</date>
				<method>#{method}</method>
				<host>#{host}</host>
				<path>#{path}</path>
				<ua>#{ua}</ua>
				<ip style='background:#{color.background};color:#{color.foreground};'>#{ip}</ip>
			</log>"

			$log.append-to $ \logs
			if ($ \logs .children \log .length) > 1024
				($ \logs .children \log)[0].remove!
			scroll 0, ($ \html .outer-height!)

function can-scroll
	$window = $ window
	height = $window.height!
	scroll-top = $window.scroll-top!
	document-height = $ document .height!
	height + scroll-top >= (document-height - 64px)
