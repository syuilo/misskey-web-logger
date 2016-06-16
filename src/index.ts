//////////////////////////////////////////////////
// MISSKEY-WEB-LOGGER
//////////////////////////////////////////////////

/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 syuilo
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

const ipc = require('node-ipc');
// import * as colors from 'colors';
const colors = require('colors/safe');

import argv from './argv';

const debug = argv.options.hasOwnProperty('debug');

ipc.config.retry = 1000;
ipc.config.silent = !debug;

ipc.connectTo('misskey-web', () => {
	const connection = ipc.of['misskey-web'];

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

		log(`${colors.gray(date)} ${method} ${colors.cyan(host)} ${colors.bold(path)} ${ua} ${colors.green(ip)}`);
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
