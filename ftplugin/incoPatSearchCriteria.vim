augroup filetype_incoPatSearchCriteria
    autocmd!
    " for Wubi input method
    iabbrev 巨 and
    iabbrev 煌 or
    iabbrev 刷业务 not
"
    " for Pinyin input method
    iabbrev 安定 and
    iabbrev 偶然 or
    iabbrev 农田 not
"
    iabbrev （ (
    iabbrev ） )
augroup END

function! s:PrettyLine(line)
    let l:line = substitute(a:line, '\c\([a-z0-9-]\+\)\s*=\s*', '\L\1 = ', 'g')
    let l:line = substitute(l:line, '\c\S\zs\s*\<\(and\|or\|to\)\>\s*\ze\S', ' \L\1 ', 'g')
    let l:line = substitute(l:line, '\c\_^\s*\zs\<\(and\|not\)\>\s*', '\L\1 ', 'g')
    let l:line = substitute(l:line, '\c\_^\s*\zs\<\(or\)\>\s*', '\L\1  ', 'g')
    let l:line = substitute(l:line, '\([\[(]\)\s*\ze\S', '\1', 'g')
    let l:line = substitute(l:line, '\S\zs\s*\([\])]\)', '\1', 'g')
    let l:line = substitute(l:line, '\c[A-Z0-9]\@<!\([A-HY]\|[A-HY]\d\{2}\|[A-HY]\d\{2}[A-Z]\|[A-HY]\d\{2}[A-Z]\d\{1,4}\|[A-HY]\d\{2}[A-Z]\d\{1,4}\/\d\{1,5}\)[/A-Z0-9]\@!', '\U\1', 'g')
    let l:line = substitute(l:line, '\s\+$', '', 'g')
    let l:line = substitute(l:line, '\(\s*\<or\>\s*\)\{2,}', ' or ', 'g')
    return l:line
endfunction

function! s:BeautySC() range
    let l:saveCursor = getpos(".")
    let l:unnamed = getreg('"')
    let l:lines = getline(1, '$')
    call map(l:lines, 's:PrettyLine(v:val)')
    execute("%delete")
    call setline(1, l:lines)
    call setpos(".", l:saveCursor)
    call setreg('"', l:unnamed)
    echo "Beauty search criteria run over!"
    unlet l:saveCursor
    unlet l:unnamed
    unlet l:lines
endfunction

function! s:CopyOneLine() range
    let l:lines = getline(a:firstline, a:lastline)
    call map(l:lines, 's:PrettyLine(v:val)')
    let l:string = join(l:lines, "\n")
    let l:string = substitute(l:string, '\_s\+', " ", "g")
    let l:string = substitute(l:string, '[\(\[]\zs\_s\+', "", "g")
    let l:string = substitute(l:string, '\_s\+\ze[\)\]]', "", "g")
    let @+ = trim(l:string)
    echom "Oneline-incoPatSearchCriteria has been copied to clipboard!"
    unlet l:lines
endfunction

function! s:JoinLinesWithOR() range
    let l:saveCursor = getpos(".")
    let l:unnamed = getreg('"')
    if a:firstline ==# a:lastline
        if a:lastline ==# line('$')
            return 0
        else
            let l:lastline = a:lastline + 1
        endif
    else
        let l:lastline = a:lastline
    endif
    let l:_indent = repeat(" ", indent(a:firstline))
    let l:lines = getline(a:firstline, l:lastline)
    call map(l:lines, 'trim(v:val)')
    let l:string = join(l:lines, ' or ')
    let l:string = substitute(l:string, '\(\s*\<or\>\s*\)\{2,}', ' or ', 'g')
    silent execute a:firstline . "," . l:lastline . 'delete'
    call append(a:firstline - 1, l:_indent . l:string)
    call setpos(".", l:saveCursor)
    call setreg('"', l:unnamed)
    unlet l:saveCursor
    unlet l:_indent
    unlet l:lines
    unlet l:string
    unlet l:unnamed
endfunction

function! s:SplitLineWithOR() range
    let l:saveCursor = getpos(".")
    let l:unnamed = getreg('"')
    let l:_indent = repeat(" ", indent(a:firstline))
    let l:string = join(getline(a:firstline, a:lastline), ' or ')
    let l:string = trim(l:string)
    let l:lines = uniq(split(l:string, '\c\(\s*\<or\>\s*\)\+'), "i")
    call map(l:lines, 'l:_indent . v:val')
    silent execute a:firstline . "," . a:lastline . 'delete'
    call append(a:firstline - 1, l:lines)
    echom len(l:lines) . " keywords found."
    call setpos(".", l:saveCursor)
    call setreg('"', l:unnamed)
    unlet l:saveCursor
    unlet l:_indent
    unlet l:lines
    unlet l:string
    unlet l:unnamed
endfunction

function! s:GenerateSCFromList() range
    let l:unnamed = getreg('"')
    normal! dip
    let l:lines = getreg('"')
    call filter(l:lines, 'v:val !~ "^\\s*\\d\\|隐藏\\|不公开\\|^\\s*$"')
    call map(l:lines, 'substitute(v:val, "[\\r\\n]", " ", "g")')
    call map(l:lines, 'substitute(v:val, "\\d\\{1,2}\.\\d\\{1,2}%$", "", "g")')
    call map(l:lines, 'substitute(v:val, "^[ \"]*\\|[ \"]*$", "\"", "g")')
    call sort(uniq(l:lines, "i"), "i")
    let l:line = "who = (" . join(l:lines, ' or ') . ")"
    call append(line("."), l:line)
    " call setpos(".", [0, 1, 1, 0])
    call setreg('"', l:unnamed)
    unlet l:lines
    unlet l:line
    unlet l:unnamed
endfunction

function! s:FixSCinBracket(Sorted=v:false)
    let l:save_register_plus = @z
    execute "normal! va)\<esc>"
    let l:_indent = repeat(" ", indent("'<") + 8)
    normal! gv"zd
    let l:line = trim(@z, "()")
    let l:lines = split(l:line, '\c\s*\(\<or\>\|[\r\n]\)\+\s*')
    call map(l:lines, 'trim(v:val)')
    call filter(l:lines, 'strlen(v:val)')
    call filter(l:lines, 'v:val !~ "^\\s*\\d\\|隐藏\\|不公开\\|^\\s*$"')
    call map(l:lines, 'substitute(v:val, "\\w\\+", "\\L\\u&", "g")')
    if a:Sorted
      call sort(l:lines, "i")
    endif
    let l:lines = uniq(l:lines, 'i')
    let l:res = []
    for l:line in l:lines
        if len(l:res) == 0
            call add(l:res, l:_indent . l:line)
        elseif strlen(get(l:res, -1)) < 100
            let l:res[-1] .= " or " . l:line
        else
            call add(l:res, l:_indent[:-5] . "or  " . l:line)
        endif
    endfor
    let @z = "(\n" . join(l:res, "\n") . "\n)"
    normal! "zp
    let @z = l:save_register_plus
    unlet l:save_register_plus
    unlet l:lines
    unlet l:line
endfunction

function! s:GetElements() range
    let l:lines = getline(a:firstline, a:lastline)
    let l:lines = map(l:lines, 'substitute(v:val, "\\s*[:：\\[\\]()（）]\\+\\s*", " ", "g")')
    " 删除方括号和圆括号
    let l:lines = map(l:lines, 'substitute(v:val, "\\s\\+", " ", "g")')
    " 多个连续的空格替换为单个空格
    call map(l:lines, 'trim(v:val)')
    let l:lines = filter(l:lines, 'v:val !~ "^\\s*$"')
    call uniq(l:lines, "i")
    " let @+ = join(l:lines, "\n")
    call setreg("+", join(l:lines, "\n"))
    echo len(l:lines) . " 行检索要素已经被复制到剪贴板！"
    unlet l:lines
endfunction

command!       -nargs=0 -range=% BeautySC         : <line1>,<line2>call <SID>BeautySC()
command!       -nargs=0 -range   JoinLinesWithOR  : <line1>,<line2>call <SID>JoinLinesWithOR()
command!       -nargs=0 -range   SplitLinesWithOR : <line1>,<line2>call <SID>SplitLineWithOR()
command!       -nargs=0 -range=% GetElements      : <line1>,<line2>call <SID>GetElements()
command!       -nargs=0 -range=% CopyOneLine      : <line1>,<line2>call <SID>CopyOneLine()
command!       -nargs=0 GenerateSCFromList        : call <SID>GenerateSCFromList()
command! -bang -nargs=0 FixSCinBracket            : call <SID>FixSCinBracket(<bang>0)

nnoremap <silent> <Plug>BeautySC           : BeautySC<cr>
nnoremap <silent> <Plug>JoinLinesWithOR    : JoinLinesWithOR<cr>
nnoremap <silent> <Plug>SplitLinesWithOR   : SplitLinesWithOR<cr>
nnoremap <silent> <Plug>GetElements        : GetElements<cr>
nnoremap <silent> <Plug>CopyOneLine        : CopyOneLine<cr>
nnoremap <silent> <Plug>GenerateSCFromList : GenerateSCFromList<cr>
nnoremap <silent> <Plug>FixSCinBracket     : FixSCinBracket<cr>
nnoremap <silent> <Plug>SortSCinBracket    : FixSCinBracket!<cr>
