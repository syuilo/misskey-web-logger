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
	name: 'debug',
	type: 'boolean',
	description: 'Enable debug mode',
	example: "misskey-web-logger --debug"
}]);

export default argv.run();
