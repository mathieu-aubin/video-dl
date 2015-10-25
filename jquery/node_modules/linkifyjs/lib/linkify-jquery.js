'use strict';

exports.__esModule = true;

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _jquery = require('jquery');

var _jquery2 = _interopRequireDefault(_jquery);

var _linkifyElement = require('./linkify-element');

var _linkifyElement2 = _interopRequireDefault(_linkifyElement);

var doc = undefined;

try {
	doc = document;
} catch (e) {
	doc = null;
}

// Applies the plugin to jQuery
function apply($) {
	var doc = arguments[1] === undefined ? null : arguments[1];

	$.fn = $.fn || {};

	try {
		doc = doc || window && window.document || global && global.document;
	} catch (e) {}

	if (!doc) {
		throw new Error('Cannot find document implementation. ' + 'If you are in a non-browser environment like Node.js, ' + 'pass the document implementation as the third argument to linkifyElement.');
	}

	if (typeof $.fn.linkify === 'function') {
		// Already applied
		return;
	}

	function jqLinkify(opts) {
		opts = _linkifyElement2['default'].normalize(opts);
		return this.each(function () {
			_linkifyElement2['default'].helper(this, opts, doc);
		});
	}

	$.fn.linkify = jqLinkify;

	$(doc).ready(function () {
		$('[data-linkify]').each(function () {

			var $this = $(this),
			    data = $this.data(),
			    target = data.linkify,
			    nl2br = data.linkifyNlbr,
			    options = {
				linkAttributes: data.linkifyAttributes,
				defaultProtocol: data.linkifyDefaultProtocol,
				events: data.linkifyEvents,
				format: data.linkifyFormat,
				formatHref: data.linkifyFormatHref,
				newLine: data.linkifyNewline, // deprecated
				nl2br: !!nl2br && nl2br !== 0 && nl2br !== 'false',
				tagName: data.linkifyTagname,
				target: data.linkifyTarget,
				linkClass: data.linkifyLinkclass
			};
			var $target = target === 'this' ? $this : $this.find(target);
			$target.linkify(options);
		});
	});
}

// Apply it right away if possible
if (typeof _jquery2['default'] !== 'undefined' && doc) {
	apply(_jquery2['default'], doc);
}

exports['default'] = apply;
module.exports = exports['default'];
/* do nothing for now */