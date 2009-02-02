CodeHighlighter.addStyle("html", {
  xml : {
    exp : /^\s*&lt;\?xml .*?\?&gt;/
	},
	doctype : {
		exp: /&lt;!DOCTYPE([^&]|&[^g]|&g[^t])*&gt;/
	},
	comment : {
		exp: /&lt;!\s*(--([^-]|[\r\n]|-[^-])*--\s*)&gt;/
	},
	tag : {
		exp: /(&lt;)(\/?)([a-zA-Z0-9]+\s?)/, 
		replacement: "<span class=\"brackets\">$1</span>$2<span class=\"$0\">$3</span>"
	},
	brackets : {
    exp: /&gt;|&lt;/
	},
/*	string : {
		exp  : /'[^']*'|"[^"]*"/
	},*/
	attribute : {
		exp: /\b([a-zA-Z-:]+)(=)('[^']*'|"[^"]*")/, 
		replacement: "<span class=\"attribute\">$1</span><span class=\"separator\">$2</span><span class=\"value\">$3</span>"
	}
});