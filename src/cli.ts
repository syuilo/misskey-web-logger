const colors = require('colors/safe');
import argv from './argv';
import ipc from './ipc';

const debug = argv.options['debug'] || false;

ipc(connection => {
	connection.on('connect', () => {
		info('Connected to MisskeyWeb');
	});

	connection.on('disconnect', () => {
		info('Disconnected from MisskeyWeb');
	});

	connection.on('misskey.log', (data: any) => {
		const date = data.date;
		const method = data.method;
		const host = data.host;
		const path = data.path;
		const ua = data.ua;
		const ip = data.ip;
		const worker = data.worker;

		/* tslint:disable max-line-length */
		log(`${colors.gray(date)} ${method} ${colors.cyan(host)} ${colors.bold(path)} ${ua} ${colors.green(ip)} ${colors.gray('(' + worker + ')')}`);
		/* tslint:enable max-line-length */
	});
});

function info(msg: string): void {
	if (debug) {
		log(`### ${msg} ###`);
	}
}

function log(msg: string): void {
	process.stdout.write(msg + '\n');
}
