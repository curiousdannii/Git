/*

Emglken port of Git
===================

Copyright (c) 2017 Dannii Willis
MIT licenced
https://github.com/curiousdannii/emglken

*/

const EmglkenVM = require( '../emglken/emglken_vm.js' )

class Git extends EmglkenVM
{

	default_options()
	{
		return {
			dirname: __dirname,
			emptfile: 'git-core.js.bin',
			module: require( './git-core.js' ),

			cache_len: 256 * 1024,
			undo_len: 2000 * 1000,
		}
	}

	setsig()
	{
		this.signature = ''
		var i = 0
		while ( i < 64 )
		{
			this.signature += ( this.data[i] < 0x10 ? '0' : '' ) + this.data[i++].toString( 16 )
		}
	}
	
	start()
	{
		this.vm.ccall(
			'emgiten',
			null,
			[ 'array', 'number', 'number', 'number' ],
			[ this.data, this.data.length, this.options.cache_len, this.options.undo_len ],
			{ async: true }
		)
		delete this.data
	}

}

module.exports = Git