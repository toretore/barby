CodeHighlighter.addStyle("css", {
	comments : {
		exp  : /\/\*[^*]*\*+([^\/][^*]*\*+)*\//
	},
	keywords : {
		exp  : /@\w[\w\s]*/
	},
	selectors : {
		exp  : "([\\w-:\\[.#\\*][^{};>]*)(?={)"
	},
	properties : {// + values
		exp  : "([\\w-]+)(\\s*:\\s*)(.*?)(\\s*;)",
		replacement: '<span class="properties">$1</span>$2<span class="values">$3</span>$4'
	},
/*	units : {
		exp  : /([0-9])(em|en|px|%|pt)\b/,
		replacement : "$1<span class=\"$0\">$2</span>"
	},
	urls : {
		exp  : /url\([^\)]*\)/
	},*/
	curly : {
    exp : /\{|\}/
	}
 });
