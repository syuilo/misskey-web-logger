//////////////////////////////////////////////////
// ARGV MANAGER
//////////////////////////////////////////////////

import * as argv from 'argv';

argv.option({
	name: 'debug',
	type : 'string',
	description: 'Enable debug mode',
	example: "misskey-web-logger --debug"
});

export default argv.run();
