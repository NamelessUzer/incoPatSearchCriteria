" Vim syntax file
" Language:	Search Criteria
" Maintainer:	Lin Kun <ssfjhh at gmail.com>
" Last Change:	2017 Oct 15

if exists("b:current_syntax")
    finish
endif

syntax clear
syntax case     ignore       " 忽略大小写

set cindent shiftwidth=8     " 自动缩进4空格
set tabstop=8                " 设置tab键的宽度

syntax keyword Keyword and or not to
syntax keyword Operator = > >= < <=
syntax keyword Delimiter $ * ?

syntax match scConnector "\c(\([1-9]\?[wn]\|sen\|s\|p\))"
syntax match scKEY "\c\(r\|rad\|rpd\|[a-z][-a-z]*[a-z0-9]\)\ze\s*=\s*[[(]\?"
syntax match scPC '\<\([A-HY]\d\{2}[A-Z]\d\{1,4}/\d\{1,6}\(\([A-Z]\d[A-Z]\d\?\|[A-Z]\d\?\)\|\.\(\d*[A-Z]\|\d\+\)\)\?\|[A-HY]\d\{2}[A-Z]\d\{1,4}/\d{1,6}\?\|[A-HY]\d\{2}[A-Z]\d\{1,4}/\?\|[A-HY]\d\{2}[A-Z]\?\|[A-HY]\)\>'
syntax match scUC '\<\d\+/\d\+\(\.\d\+\)\?\|\d\+/\|\d\+\>'
syntax match scComment /#.*/
syntax region scString matchgroup=scQuote start=/"/ end=/"/
" syntax region scString matchgroup=scQuote start=/\v"/ skip=/\v\\./ end=/\v"/ " 因为检索式不支持转义的特殊字符，因此skip参数是不需要的

highlight link scConnector Delimiter
highlight link scPC        Number
highlight link scUC        Number
highlight link scKEY       Identifier
highlight link scComment   Comment
highlight link scString    String

highlight scQuote ctermfg=green guifg=green

let b:current_syntax = "incoPatSearchCriteria"
