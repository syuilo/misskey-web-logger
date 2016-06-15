const ipc = require('node-ipc');

ipc.config.id = 'syuilo/misskey-web-logger';
ipc.config.retry = 1000;
ipc.config.silent = true;

ipc.connectToNet('misskey-web', () => {
	const connection = ipc.of['misskey-web'];

	connection.on('connect', () => {
		console.log('## connected to MisskeyWeb ##');
	});

	connection.on('disconnect', () => {
		console.log('## disconnected from MisskeyWeb ##');
	});

	connection.on('misskey.log', (data: any) => {
		console.log(data.path);
	});

	console.log(connection.destroy);
});
