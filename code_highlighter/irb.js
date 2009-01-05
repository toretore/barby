CodeHighlighter.addStyle("irb",{
	input : {
		exp  : /([\r\n]+|^)(.*?&gt;&gt;)(.*?)(?=[\r\n]+|$)/,
		replacement : '$1<span class="input prompt">$2</span><span class="input code">$3</span>'
	},
	output : {
		exp  : /([\r\n]+|^)(.*?=&gt;)(.*?)(?=[\r\n]+|$)/,
		replacement : '$1<span class="output prompt">$2</span><span class="output code">$3</span>'
	}
});