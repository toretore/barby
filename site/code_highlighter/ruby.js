CodeHighlighter.addStyle("ruby",{
	comment : {
		exp  : /#[^\n]+/
	},
	parens : {
		exp  : /\(|\)/
	},
	brackets : {
    exp : /\[|\]/
	},
	curly : {
    exp : /\{|\}/
	},
	string : {
		exp  : /'[^']*'|"[^"]*"/
	},
	keywords : {
		exp  : /\b(do|end|self|class|def|if|module|yield|then|else|for|until|unless|while|elsif|case|when|break|retry|redo|rescue|require|raise)\b/
	},
	/* Added by Shelly Fisher (shelly@agileevolved.com) */
	symbol : {
	  exp : /:[A-Za-z0-9_!?]+/
	},
	instance : {
    exp : /[^@]@[a-zA-Z0-9_]+/
	},
	'class' : {
    exp : /@@[a-zA-Z0-9_]+/
	},
	numbers : {
    exp : /[0-9][0-9\._]*/
	},
  constants : {
    exp : /(:{0,2}[A-Z][a-zA-Z]*)+/
  }
});