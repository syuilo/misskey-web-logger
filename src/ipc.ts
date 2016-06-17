import argv from './argv';
const ipc = require('node-ipc');

const debug = argv.options['debug'] || false;

const id = 'misskey-web';

ipc.config.retry = 1000;
ipc.config.silent = !debug;

export default function(cb: (connection: any) => void): void {
	ipc.connectTo(id, () => {
		cb(ipc.of[id]);
	});
}
