import argv from './argv';
const ipc = require('node-ipc');

const debug = argv.options['debug'] || false;

ipc.config.retry = 1000;
ipc.config.silent = !debug;

export default function(cb: (connection: any) => void): void {
	ipc.connectTo('misskey-web', () => {
		cb(ipc.of['misskey-web']);
	});
}
