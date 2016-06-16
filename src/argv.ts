//////////////////////////////////////////////////
// ARGV MANAGER
//////////////////////////////////////////////////

import * as argv from 'argv';

argv.option([{
	name: 'version',
	short: 'v',
	type: 'boolean',
	description: 'Display version',
	example: "misskey-web-logger -v"
}, {
	name: 'web',
	short: 'w',
	type: 'boolean',
	description: 'Serve Web',
	example: "misskey-web-logger -w"
}, {
	name: 'port',
	short: 'p',
	type: 'int',
	description: 'Web port',
	example: "misskey-web-logger -w -p 907"
}, {
	name: 'debug',
	type: 'boolean',
	description: 'Enable debug mode',
	example: "misskey-web-logger --debug"
}]);

export default argv.run();
