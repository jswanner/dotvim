" Language:    Coco
" Maintainer:  satyr
" URL:         http://github.com/satyr/vim-coco
" License:     WTFPL

if exists('b:current_syntax') && b:current_syntax == 'coco'
  finish
endif

let b:current_syntax = "co"

" Highlight long strings.
syntax sync minlines=100

setlocal iskeyword=48-57,A-Z,$,a-z,_

syntax match coIdentifier /[$A-Za-z_]\k*/
highlight default link coIdentifier Identifier

" These are 'matches' rather than 'keywords' because vim's highlighting priority
" for keywords (the highest) causes them to be wrongly highlighted when used as
" dot-properties.
syntax match coStatement /\<\%(return\|break\|continue\|throw\)\>/
highlight default link coStatement Statement

syntax match coRepeat /\<\%(for\%( own\| ever\)\?\|while\|until\)\>/
highlight default link coRepeat Repeat

syntax match coConditional /\<\%(if\|else\|unless\|switch\|case\|default\)\>/
highlight default link coConditional Conditional

syntax match coException /\<\%(try\|catch\|finally\)\>/
highlight default link coException Exception

syntax match coKeyword /\<\%(new\|in\%(stanceof\)\?\|typeof\|delete\|and\|o[fr]\|not\|is\|import\%( all\)\?\|extends\|from\|to\|til\|by\|do\|then\|function\|class\|let\|with\|export\|eval\|super\|fallthrough\|debugger\)\>/
highlight default link coKeyword Keyword

syntax match coBoolean /\<\%(true\|false\|null\|void\)\>/
highlight default link coBoolean Boolean

" Matches context variables.
syntax match coContext /\<\%(this\|arguments\|it\|that\|constructor\|prototype\|superclass\)\>/
highlight default link coContext Type

" Keywords reserved by the language
syntax cluster coReserved contains=coStatement,coRepeat,coConditional,
\                                  coException,coOperator,coKeyword,coBoolean

" Matches ECMAScript 5 built-in globals.
syntax match coGlobal /\<\%(Array\|Boolean\|Date\|Function\|JSON\|Math\|Number\|Object\|RegExp\|String\|\%(Syntax\|Type\|URI\)\?Error\|is\%(NaN\|Finite\)\|parse\%(Int\|Float\)\|\%(en\|de\)codeURI\%(Component\)\?\)\>/
highlight default link coGlobal Structure

syntax region coString start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=@coInterpString
syntax region coString start=/'/ skip=/\\\\\|\\'/ end=/'/ contains=@coSimpleString
highlight default link coString String

" Matches decimal/floating-point numbers like 10.42e-8.
syntax match coFloat
\ /\<\d[0-9_]*\%(\.\d[0-9_]*\)\?\%(e[+-]\?\d[0-9_]*\)\?\k*/
\ contains=coNumberComment
highlight default link coFloat Float
syntax match coNumberComment /\d\+\zs\%(e[+-]\?\d\)\@!\k*\>/ contained
highlight default link coNumberComment Comment
" Matches hex numbers like 0xfff, 0x000.
syntax match coNumber /\<0x\x\+/
" Matches N radix numbers like 2r1010.
syntax match coNumber
\ /\<\%([2-9]\|[12]\d\|3[0-6]\)r[0-9A-Za-z][0-9A-Za-z_]*/
highlight default link coNumber Number

" Displays an error for reserved words.
syntax match coReservedError /\<\%(var\|const\|enum\|implements\|interface\|package\|private\|protected\|public\|static\|yield\)\>/
highlight default link coReservedError Error

syntax keyword coTodo TODO FIXME XXX contained
highlight default link coTodo Todo

syntax match  coComment /#.*/                   contains=@Spell,coTodo
syntax region coComment start=/\/\*/ end=/\*\// contains=@Spell,coTodo
highlight default link coComment Comment

syntax region coEmbed start=/`/ skip=/\\\\\|\\`/ end=/`/
highlight default link coEmbed Special

syntax region coInterpolation matchgroup=coInterpDelim
\                                 start=/\#{/ end=/}/
\                                 contained contains=TOP
highlight default link coInterpDelim Delimiter

" Matches escape sequences like \000, \x00, \u0000, \n.
syntax match coEscape /\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\./ contained
highlight default link coEscape SpecialChar

syntax match coVarInterpolation /#[$A-Za-z_]\k*/ contained
highlight default link coVarInterpolation Identifier

" What is in a non-interpolated string
syntax cluster coSimpleString contains=@Spell,coEscape
" What is in an interpolated string
syntax cluster coInterpString contains=@coSimpleString,
\                                      coInterpolation,coVarInterpolation

syntax region coRegex start=/\%(\%()\|\i\@<!\d\)\s*\|\i\)\@<!\/\*\@!/
\                     skip=/\[[^]]\{-}\/[^]]\{-}\]/
\                     end=/\/[gimy$]\{,4}/
\                     oneline contains=@coSimpleString
syntax region coHeregex start=/\/\// end=/\/\/[gimy$?]\{,4}/ contains=@coInterpString,coComment,coSpaceError fold
highlight default link coHeregex coRegex
highlight default link coRegex String

syntax region coHeredoc start=/"""/ end=/"""/ contains=@coInterpString fold
syntax region coHeredoc start=/'''/ end=/'''/ contains=@coSimpleString fold
highlight default link coHeredoc String

syntax match coWord /\\\S[^ \t\r,;)}\]]*/
highlight default link coWord String

syntax region coWords start=/<\[/ end=/\]>/ contains=fold
highlight default link coWords String

" Reserved words can be used as property names.
syntax match coProp /[$A-Za-z_]\k*[ \t]*:[:=]\@!/
highlight default link coProp Label

syntax match coKey
\ /\%(\.\@<!\.\%(=\?\s*\|\.\)\|[]})@?]\|::\)\zs\k\+/
\ transparent
\ contains=ALLBUT,coIdentifier,coContext,coGlobal,coReservedError,@coReserved 

" Displays an error for trailing whitespace.
syntax match coSpaceError /\s\+$/ display
highlight default link coSpaceError Error

if !exists('b:current_syntax')
  let b:current_syntax = 'coco'
endif
