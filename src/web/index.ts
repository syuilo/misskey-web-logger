//////////////////////////////////////////////////
// WEB INTERFACE
//////////////////////////////////////////////////

import * as express from 'express';
import * as io from 'socket.io';
import argv from '../argv';
import ipc from '../ipc';
import paint from '../util/paint';

const debug = argv.options['debug'] || false;

let webinfo: any = null;

//////////////////////////////////////////////////
// WEB SERVER

const app = express();
app.disable('x-powered-by');
app.locals.compileDebug = false;
app.locals.cache = true;
app.set('view engine', 'pug');
app.set('views', __dirname);

app.get('/', (req, res) => {
	res.render('view');
});

app.get('/style', (req, res) => {
	res.sendFile(__dirname + '/style.css');
});

app.get('/script', (req, res) => {
	res.sendFile(__dirname + '/script.js');
});

const server = app.listen(argv.options['port']);

//////////////////////////////////////////////////
// STREAMING SERVER

const oi = io(server);

oi.on('connection', socket => {
	socket.emit('info', webinfo);
});

//////////////////////////////////////////////////
// IPC CONNECTION

ipc(connection => {
	connection.on('connect', () => {
		info('Connected to MisskeyWeb');
	});

	connection.on('disconnect', () => {
		info('Disconnected from MisskeyWeb');
	});

	connection.on('misskey.info', (data: any) => {
		webinfo = data;
		oi.emit('info', data);
	});

	connection.on('misskey.log', (data: any) => {
		data.color = paint(data.ip);
		oi.emit('log', data);
	});
});

function info(msg: string): void {
	if (debug) {
		console.log(`### ${msg} ###`);
	}
}
