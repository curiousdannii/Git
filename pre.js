// Emglken prefix code for Git
(function(){

// Utility to extend objects
function extend()
{
	var old = arguments[0], i = 1, add, name;
	while ( i < arguments.length )
	{
		add = arguments[i++];
		for ( name in add )
		{
			old[name] = add[name];
		}
	}
	return old;
}

var GiDispa
var Glk

var default_options = {
	cache_len: 256 * 1024,
	undo_len: 2000 * 1000,
}

// Give this Emscripten module the Quixe API
var Module = {

	// Store the data and options
	prepare: function( data, options )
	{
		// If we are not given a glk option then we cannot continue
		if ( !options.Glk )
		{
			throw new Error( 'A reference to Glk is required' )
		}
		GiDispa = options.GiDispa
		Glk = options.Glk
		this.data = data
		this.options = extend( {}, default_options, options )

		// Cache the game signature
		var signature = ''
		var i = 0
		while ( i < 64 )
		{
			signature += ( this.data[i] < 0x10 ? '0' : '' ) + this.data[i++].toString( 16 )
		}
		this.signature = signature

		this.loadMem()
	},

	// Call emgiten()
	init: function()
	{
		this.ccall(
			'emgiten',
			null,
			[ 'array', 'number', 'number', 'number' ],
			[ this.data, this.data.length, this.options.cache_len, this.options.undo_len ],
			{ async: true }
		)
		delete this.data
	},

	resume: function( res )
	{
		this.glem_callback( res )
	},

	get_signature: function()
	{
		return this.signature
	},

	// Find the .mem file
	locateFile: function( filename )
	{
		if ( ENVIRONMENT_IS_NODE )
		{
			return __dirname + '/' + filename
		}
		return filename
	},

	// A dummy XHR to delay loading
	memoryInitializerRequest: typeof XMLHttpRequest !== 'undefined' && new XMLHttpRequest(),

	// Load memory in the browser
	loadMem: function()
	{
		if ( ENVIRONMENT_IS_WEB )
		{
			if ( this.options.memdir )
			{
				memoryInitializer = this.options.memdir + '/' + memoryInitializer
			}
			doBrowserLoad()
		}
		delete this.memoryInitializerRequest
	},

}