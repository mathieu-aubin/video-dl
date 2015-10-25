'use strict';

exports.__esModule = true;

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj['default'] = obj; return newObj; } }

var _linkifyUtilsOptions = require('./linkify/utils/options');

var options = _interopRequireWildcard(_linkifyUtilsOptions);

var _linkifyCoreScanner = require('./linkify/core/scanner');

var scanner = _interopRequireWildcard(_linkifyCoreScanner);

var _linkifyCoreParser = require('./linkify/core/parser');

var parser = _interopRequireWildcard(_linkifyCoreParser);

if (!Array.isArray) {
	Array.isArray = function (arg) {
		return Object.prototype.toString.call(arg) === '[object Array]';
	};
}

/**
	Converts a string into tokens that represent linkable and non-linkable bits
	@method tokenize
	@param {String} str
	@return {Array} tokens
*/
var tokenize = function tokenize(str) {
	return parser.run(scanner.run(str));
};

/**
	Returns a list of linkable items in the given string.
*/
var find = function find(str) {
	var type = arguments[1] === undefined ? null : arguments[1];

	var tokens = tokenize(str),
	    filtered = [];

	for (var i = 0; i < tokens.length; i++) {
		if (tokens[i].isLink && (!type || tokens[i].type === type)) {
			filtered.push(tokens[i].toObject());
		}
	}

	return filtered;
};

/**
	Is the given string valid linkable text of some sort
	Note that this does not trim the text for you.

	Optionally pass in a second `type` param, which is the type of link to test
	for.

	For example,

		test(str, 'email');

	Will return `true` if str is a valid email.
*/
var test = function test(str) {
	var type = arguments[1] === undefined ? null : arguments[1];

	var tokens = tokenize(str);
	return tokens.length === 1 && tokens[0].isLink && (!type || tokens[0].type === type);
};

// Scanner and parser provide states and tokens for the lexicographic stage
// (will be used to add additional link types)
exports.find = find;
exports.options = options;
exports.parser = parser;
exports.scanner = scanner;
exports.test = test;
exports.tokenize = tokenize;