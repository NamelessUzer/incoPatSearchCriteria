augroup filetype_SearchCriteria
    autocmd!
    nnoremap <localleader>b :call Beauty_SearchCriteria()<cr>
    nnoremap <localleader>o :call JoinLinesWithOR()<cr>
    nnoremap <localleader>s :call SplitLineWithOR()<cr>
    nnoremap <localleader>i :call SortIPC()<cr>
    nnoremap <localleader>e :call GetElements()<cr>
    " 从检索式生成检索要素（去除括号， and or not = 等字符)
    nnoremap <localleader>c :call Copy_SearchCriteria_oneline()<cr>
    " nnoremap <localleader>G :set operatorfunc = SortOperator<cr>G@
    nnoremap <localleader>f :call GenerateSCFromList()<cr>
    nnoremap <localleader>F :call GenerateListFromSC()<cr>
    " nnoremap <localleader>F :normal! gg/ap\s*=\s*(/e<cr>n"zyi)ggdG"zP<cr>

    iabbrev 刷业务 not
    iabbrev 巨 and
    iabbrev 煌 or
    iabbrev （ (
    iabbrev ） )
augroup END

function! Pretty_SearchCriteria(lines)
    let l:lst = []
    for l:line in copy(a:lines)
        let l:line = substitute(l:line, '\c\([a-z0-9-]\+\)\s*=\s*', '\L\1 = ', 'g')
        let l:line = substitute(l:line, '\c\S\zs\s*\<\(and\|or\|to\)\>\s*\ze\S', ' \L\1 ', 'g')
        let l:line = substitute(l:line, '\c\_^\s*\zs\<\(and\|not\)\>\s*', '\L\1 ', 'g')
        let l:line = substitute(l:line, '\c\_^\s*\zs\<\(or\)\>\s*', '\L\1  ', 'g')
        let l:line = substitute(l:line, '\([\[(]\)\s*\ze\S', '\1', 'g')
        let l:line = substitute(l:line, '\S\zs\s*\([\])]\)', '\1', 'g')
        let l:line = substitute(l:line, '\c[A-Z0-9]\@<!\([A-HY]\|[A-HY]\d\{2}\|[A-HY]\d\{2}[A-Z]\|[A-HY]\d\{2}[A-Z]\d\{1,4}\|[A-HY]\d\{2}[A-Z]\d\{1,4}\/\d\{1,5}\)[/A-Z0-9]\@!', '\U\1', 'g')
        let l:line = substitute(l:line, '\s\+$', '', 'g')
        let l:line = substitute(l:line, '\(\s*\<or\>\s*\)\{2,}', ' or ', 'g')
        " 将多个or替换为一个or，检索式中常出现这一错误
        call add(l:lst, l:line)
    endfor
    unlet l:line
    return l:lst
endfunction

function! Beauty_SearchCriteria()
    let l:save_cursor = getpos(".")
    " 备份光标位置
    let l:lines = getline(1, '$')
    " 复制缓冲区中所有内容复制到变量string，方便进行后续操作
    let l:lines = Pretty_SearchCriteria(l:lines)
    " 使用Pretty_SearchCriteria函数美化检索式
    execute "normal! ggdG"
    " 清空缓冲区
    call setline(1, l:lines)
    " 将美化后的检索式回写到缓冲区
    call setpos(".", l:save_cursor)
    " 恢复光标位置
    echo "Beauty_SearchCriteria run over!"
    unlet l:save_cursor
    unlet l:lines
endfunction

function! Copy_SearchCriteria_oneline()
    " silent execute 'normal! ggVG"ay'
    " 复制缓冲区中所有内容复制到寄存器a，方便进行后续操作，不方便已经放弃使用这一方法
    let l:lines = getline(1, '$')
    " 复制缓冲区中所有内容复制到变量string，方便进行后续操作
    let l:lines = Pretty_SearchCriteria(l:lines)
    " 使用Pretty_SearchCriteria函数美化检索式
    let l:string = join(l:lines, "\n")
    let l:string = substitute(l:string, '\_s\+', " ", "g")
    " 将多个连续的空格及换行替换为一个空格
    let l:string = substitute(l:string, '[\(\[]\zs\_s\+', "", "g")
    " 将左括号内侧的空格删除
    let l:string = substitute(l:string, '\_s\+\ze[\)\]]', "", "g")
    " 将右括号内侧的空格删除
    let @+ = substitute(l:string, '^\_s\+\|\_s\+$', "", "g")
    " 将一行式检索式末尾的换行去除并放置到系统剪贴板
    echom "Oneline-SearchCriteria has been copied to clipboard!"
    unlet l:lines
endfunction


function! JoinLinesWithOR() range
    let l:save_cursor = getpos(".")
    " 标记当前位置
    " silent execute "kq"
    " 标记当前位置，同normal! mq，优点是更为简短
    if a:firstline ==# a:lastline
        if a:lastline ==# line('$')
            return 0
        else
            let l:lastline = a:lastline + 1
        endif
    else
        let l:lstline = a:lastline
    endif

    " 将多个or替换为一个or，用or连接行时常出现这一错误
    let l:_indent = repeat(" ", indent(a:firstline))
    " 获取缩进值备用
    let l:lines = getline(a:firstline, l:lastline)
    let l:lines = map(l:lines, 'substitute(v:val, "^\\_s\\+\\|\\_s\\+$", "", "g")')
    " 删除行首行尾空格和空行
    let l:string = join(l:lines, ' or ')
    " 使用or连接多行
    let l:string = substitute(l:string, '\(\s*\<or\>\s*\)\{2,}', ' or ', 'g')
    silent execute a:firstline . "," . l:lastline . 'delete'
    call append(a:firstline - 1, l:_indent . l:string)
    call setpos(".", l:save_cursor)
    " silent execute "'q"
    unlet l:save_cursor
    unlet l:_indent
    unlet l:lines
    unlet l:string
endfunction

function! SplitLineWithOR() range
    let l:save_cursor = getpos(".")
    let l:_indent = repeat(" ", indent(a:firstline))
    " 获取缩进值备用
    let l:string = join(getline(a:firstline, a:lastline), ' or ')
    " 使用or连接多行
    let l:string = substitute(l:string, '^\_s\+\|\_s\+$', '', 'g')
    " 删除行首行尾空格和空行
    let l:lines = uniq(split(l:string, '\c\(\s*\<or\>\s*\)\+'), "i")
    " 使用or分割字符串
    let l:lines = map(lines, 'l:_indent . v:val')
    " 给每一行都加上缩进
    silent execute a:firstline . "," . a:lastline . 'delete'
    " 删除用or分割前的多行
    call append(a:firstline - 1, l:lines)
    " 在原来的位置增加用or分割后的多行
    call setpos(".", l:save_cursor)
    echom len(l:lines) . " keywords found."
    unlet l:save_cursor
    unlet l:_indent
    unlet l:lines
    unlet l:string
    " 释放过程中用到的三个变量
endfunction

function! SortIPC() range
    execute "normal! mq"
    " 保存当前光标的位置，恢复用
    let l:_indent = repeat(" ", indent(a:firstline))
    " 获取缩进长度并转换为对应长度的字符串备用
    let l:lines = getline(a:firstline, a:lastline)
    " 获取选中的内容，结果是一个列表。
    let l:string = join(l:lines, ' or ')
    " 将选中的内容的字符串列表连接成一个字符串
    let l:string = substitute(l:string, '^\s\+\|\s\+$', '', 'g')
    " 去除行首行尾的多余空格
    let l:lines = sort(uniq(split(l:string, '\(\s*\<or\>\s*\)\+'), "i"), "i")
    " 将长字符串使用 or 分割成列表，然后排序，千万不要改成空格来分割，因为关键词中有可能出现空格
    echom len(l:lines) . " IPC keywords found."
    let l:string = l:_indent . join(l:lines, ' or ')
    " 将列表使用or连接起来，将加上之前保存的缩进量，形成新的行
    silent execute setline(line('.'), l:string)
    " 使用setline函数替换原来的行（不需要先添加行，再用delete删除行）
    " silent delete"可以用这条命令删除行，这里并不需要
    if a:firstline < a:lastline
        silent execute (a:firstline + 1) . "delete" . (a:lastline - a:firstline)
    endif
    unlet l:_indent
    unlet l:lines
    unlet l:string
    " 释放过程中用到的三个变量
    execute "normal! `q"
    " 恢复光标位置
endfunction

function! GenerateSCFromList()
    " 此函数用于将从incoPat的筛选器中复制出的申请人/发明人变换成检索式，查全查准的时候有用
    let l:lines = getline(1, "$")
    call filter(l:lines, 'v:val !~ "^\\s*\\d\\|隐藏\\|不公开\\|^\\s*$"')
    " 过滤不需要的行
    call map(l:lines, 'substitute(v:val, "\\d\\{1,2}\.\\d\\{1,2}%$", "", "g")')
    " 删除行尾百分数
    call map(l:lines, 'substitute(v:val, "^[ \"]*\\|[ \"]*$", "\"", "g")')
    " 删除行首行尾空格并在前后都加上引号
    call sort(uniq(l:lines, "i"), "i")
    " 去重并排序
    execute "normal! ggdG"
    " 清空缓冲区
    " call setline(1, "ap = (" . join(l:lines, ' or ') . ")")
    " 将多个申请人用  or 连起来然后再括起来并加上申请人字段
    let l:l0 = "ap = (" . join(l:lines, ' or ') . ")"
    let l:l1 = "aee = (" . join(l:lines, ' or ') . ")"
    let l:l01 = "(" . l:l0 . " or " . l:l1 . ")"
    call setline(1, l:l01)
    " 将多个申请人用  or 连起来然后再括起来并加上申请人和受让人字段
    call setpos(".", [0, 1, 1, 0])
    " 将光标放置在首行首列
    unlet l:lines
    unlet l:l0
    unlet l:l1
    unlet l:l01
endfunction

function! GenerateListFromSC()
    " 此函数用于将检索式中的申请人变换成申请人列表并排序，每个申请人一行
    let l:save_register_plus = @z
    let l:save_register_unnamed = @"
    execute 'normal! gg/ap\s*=\s*(/e<cr>n"zyi)ggdG'
    let l:lines = sort(uniq(split(trim(@z), '\c\(\s*\<or\>\s*\)\+'), 'i'), "i")
    " 使用or分割字符串并去重和排序
    call map(l:lines, 'substitute(v:val, "\\w\\+", "\\L\\u&", "g")')
    call setline(1, l:lines)
    " 回写进 buffer
    let @z = l:save_register_plus
    let @" = l:save_register_unnamed
    unlet l:save_register_plus
    unlet l:save_register_unnamed
    unlet l:lines
endfunction

function! GetElements() range
    " 此函数用来从检索式中抽取检索要素
    let l:lines = getline(a:firstline, a:lastline)
    let l:lines = map(l:lines, 'substitute(v:val, "\\(ab\\|ab-otlang\\|ab-ts\\|abo\\|ad\\|adm\\|ady\\|aee\\|aeenor\\|agc\\|all\\|an\\|ann\\|aor\\|ap\\|ap-add\\|ap-country\\|ap-or\\|ap-ot\\|ap-otadd\\|ap-pc\\|ap-province\\|ap-ts\\|ap-type\\|apnor\\|assign-city\\|assign-country\\|assign-date\\|assign-flag\\|assign-party\\|assign-state\\|assign-text\\|assignee-add\\|assignee-cadd\\|assignyear\\|at\\|at-add\\|at-city\\|at-country\\|at-state\\|auth\\|bclas1\\|bclas2\\|bclas3\\|cf\\|cfn\\|city\\|claim\\|claim-en\\|claim-or\\|claim-ts\\|class\\|cn-dc\\|county\\|cp-dc\\|cpc\\|cpc-class\\|cpc-group\\|cpc-section\\|cpc-subclass\\|cpc-subgroup\\|ct\\|ct-ad\\|ct-ap\\|ct-auth\\|ct-code\\|ct-no\\|ct-pd\\|ct-times\\|ctfw\\|ctfw-ad\\|ctfw-ap\\|ctfw-auth\\|ctfw-no\\|ctfw-pd\\|ctfw-times\\|ctnp\\|ctyear\\|customs-flag\\|des\\|des-or\\|doc-dc\\|ecd\\|ecla\\|ecla-class\\|ecla-group\\|ecla-section\\|ecla-subclass\\|ecla-subgroup\\|ex\\|ex-time\\|expiry-date\\|fa-country\\|fam-dc\\|fc-dc\\|fct\\|fct-ap\\|fct-times\\|fctfw\\|fctfw-ap\\|fctfw-times\\|fi\\|filing-lang\\|ft\\|full\\|grant-date\\|ian\\|if\\|ifn\\|in\\|in-add\\|in-ap\\|in-city\\|in-country\\|in-state\\|ipc\\|ipc-class\\|ipc-group\\|ipc-main\\|ipc-section\\|ipc-subclass\\|ipc-subgroup\\|ipcm-class\\|ipcm-group\\|ipcmaintt\\|ipcm-section\\|ipcm-subclass\\|ipn\\|lawtxt\\|lee\\|lee-current\\|lg\\|lgc\\|lgd\\|lge\\|lgf\\|lgi-case\\|lgi-court\\|lgi-date\\|lgi-defendant\\|lgi-firm\\|lgi-flag\\|lgi-judge\\|lgi-no\\|lgi-party\\|lgi-plantiff\\|lgi-region\\|lgi-text\\|lgi-ti\\|lgi-type\\|lgiyear\\|licence-flag\\|license-cs\\|license-date\\|license-no\\|license-sd\\|license-stage\\|license-td\\|license-type\\|licenseyear\\|loc\\|lor\\|mf\\|mfn\\|no-claim\\|number\\|page\\|patent-life\\|patentee\\|patenteenor\\|pc-cn\\|pd\\|pdm\\|pdy\\|pee\\|pee-current\\|pfex-time\\|phc\\|pledge-cd\\|pledge-date\\|pledge-no\\|pledge-rd\\|pledge-stage\\|pledge-term\\|pledge-type\\|pledgeyear\\|plege-flag\\|pn\\|pnc\\|pnk\\|pnn\\|por\\|pr\\|pr-au\\|pr-date\\|prd\\|prn\\|pryear\\|pt\\|pu-date\\|re-ap\\|ree-flag\\|ref-dc\\|reward-level\\|reward-name\\|reward-session\\|ri-ae\\|ri-ap\\|ri-basis\\|ri-date\\|ri-inernal\\|ri-leader\\|ri-me\\|ri-num\\|ri-point\\|ri-text\\|ri-type\\|riyear\\|status\\|status-lite\\|std-company\\|std-etsi\\|std-flag\\|std-num\\|subex-date\\|ti\\|ti-otlang\\|ti-ts\\|tiab\\|tiabc\\|tio\\|uc\\|uc-main\\|vlstar\\|who\\|ap\\|ap-or\\|ap-ot\\|ap-ts\\|apnor\\|aee\\|aor\\|assign-party\\|aeenor\\|ap-otadd\\|in\\|lor\\|lee\\|lgi-party\\|at\\|agc\\|re-ap\\|in-ap\\|ri-me\\|ri-ae\\|ri-leader\\|por\\|pee\\|ex\\|ap-type\\|who\\|patentee\\|patenteenor\\|aptt\\|ap-ortt\\|ap-ottt\\|ap-tstt\\|apnortt\\|aeett\\|aortt\\|assign-partytt\\|aeenortt\\|ap-otaddtt\\|intt\\|lortt\\|leett\\|lgi-partytt\\|attt\\|agctt\\|re-aptt\\|in-aptt\\|ri-mett\\|ri-aett\\|ri-leadertt\\|portt\\|peett\\|extt\\|ap-typett\\|whott\\|patenteett\\|patenteenortt\\)\\s*=", " ", "g")')
    " 删除字段名称
    let l:lines = map(l:lines, 'substitute(v:val, "\\c\\s*\\<\\(and\\|or\\|not\\)\\>\\+\\s*", " ", "g")')
    " 删除and or not
    let l:lines = map(l:lines, 'substitute(v:val, "\\s*[:：\\[\\]()（）]\\+\\s*", " ", "g")')
    " 删除方括号和圆括号
    let l:lines = map(l:lines, 'substitute(v:val, "\\s\\+", " ", "g")')
    " 多个连续的空格替换为单个空格
    let l:lines = map(l:lines, 'substitute(v:val, "^\\s\\+\\|\\s\\+$", "", "g")')
    " 删除行首及行尾的空格
    let l:lines = filter(l:lines, 'v:val !~ "^\\s*$"')
    " 移除空行
    call uniq(l:lines, "i")
    " 去重
    let @+ = join(l:lines, "\n")
    " 使用换行符号连接多个行并且复制到系统剪贴板
    echo len(l:lines) . " 行检索要素已经被复制到剪贴板！"
    unlet l:lines
endfunction
