augroup filetype_SearchCriteria
    autocmd!
    nnoremap <localleader>b :call Beauty_SearchCriteria()<cr>
    nnoremap <localleader>o :call JoinLinesWithOR()<cr>
    nnoremap <localleader>s :call SplitLineWithOR()<cr>
    nnoremap <localleader>i :call SortIPC()<cr>
    nnoremap <localleader>e :call GetElements()<cr>
    " 从检索式生成检索要素（去除括号， and or not = 等字符)
    nnoremap <localleader>c :call Copy_SearchCriteria_oneline()<cr>
    nnoremap <localleader>d :normal! "hebd2f "<cr>
    " 光标旋转在or上，可以一并删除or及后面紧跟着的一个单词
    " nnoremap <localleader>G :set operatorfunc = SortOperator<cr>G@
    nnoremap <localleader>q mqbi"<esc>ea"<esc>`q
    nnoremap <localleader>f :call ClearData()<cr>

    iabbrev 刷业务 not
    iabbrev 巨 and
    iabbrev 煌 or
    iabbrev （ (
    iabbrev ） )
augroup END

function! Pretty_SearchCriteria(lines)
    let lst = []
    for line in copy(a:lines)
        let line = substitute(line, '\c\([a-z0-9-]\+\)\s*=\s*', '\L\1 = ', 'g')
        let line = substitute(line, '\c\S\zs\s*\<\(and\|or\|to\)\>\s*\ze\S', ' \L\1 ', 'g')
        let line = substitute(line, '\c\_^\s*\zs\<\(and\|not\)\>\s*', '\L\1 ', 'g')
        let line = substitute(line, '\c\_^\s*\zs\<\(or\)\>\s*', '\L\1  ', 'g')
        let line = substitute(line, '\([\[(]\)\s*\ze\S', '\1', 'g')
        let line = substitute(line, '\S\zs\s*\([\])]\)', '\1', 'g')
        let line = substitute(line, '\c[A-Z0-9]\@<!\([A-HY]\|[A-HY]\d\{2}\|[A-HY]\d\{2}[A-Z]\|[A-HY]\d\{2}[A-Z]\d\{1,4}\|[A-HY]\d\{2}[A-Z]\d\{1,4}\/\d\{1,5}\)[/A-Z0-9]\@!', '\U\1', 'g')
        let line = substitute(line, '\s\+$', '', 'g')
        let line = substitute(line, '\(\s*\<or\>\s*\)\{2,}', ' or ', 'g')
        " 将多个or替换为一个or，检索式中常出现这一错误
        call add(lst, line)
    endfor
    return lst
endfunction

function! Beauty_SearchCriteria()
    let save_cursor = getpos(".")
    " 备份光标位置
    let lines = getline(1, '$')
    " 复制缓冲区中所有内容复制到变量string，方便进行后续操作
    let lines = Pretty_SearchCriteria(lines)
    " 使用Pretty_SearchCriteria函数美化检索式
    execute "normal! ggdG"
    " 清空缓冲区
    call setline(1, lines)
    " 将美化后的检索式回写到缓冲区
    call setpos(".", save_cursor)
    " 恢复光标位置
    echo "Beauty_SearchCriteria run over!"
endfunction

function! Copy_SearchCriteria_oneline()
    " silent execute 'normal! ggVG"ay'
    " 复制缓冲区中所有内容复制到寄存器a，方便进行后续操作，不方便已经放弃使用这一方法
    let lines = getline(1, '$')
    " 复制缓冲区中所有内容复制到变量string，方便进行后续操作
    let lines = Pretty_SearchCriteria(lines)
    " 使用Pretty_SearchCriteria函数美化检索式
    let string = join(lines, "\n")
    let string = substitute(string, '\_s\+', " ", "g")
    " 将多个连续的空格及换行替换为一个空格
    let string = substitute(string, '[\(\[]\zs\_s\+', "", "g")
    " 将左括号内侧的空格删除
    let string = substitute(string, '\_s\+\ze[\)\]]', "", "g")
    " 将右括号内侧的空格删除
    let @+ = substitute(string, '^\_s\+\|\_s\+$', "", "g")
    " 将一行式检索式末尾的换行去除并放置到系统剪贴板
    echom "Oneline-SearchCriteria has been copied to clipboard!"
endfunction


function! JoinLinesWithOR() range
    let save_cursor = getpos(".")
    " 标记当前位置
    " silent execute "kq"
    " 标记当前位置，同normal! mq，优点是更为简短
    if a:firstline ==# a:lastline
        if a:lastline ==# line('$')
            return 0
        else
            let lastline = a:lastline + 1
        endif
    else
        let lastline = a:lastline
    endif

    " 将多个or替换为一个or，用or连接行时常出现这一错误
    let _indent = repeat(" ", indent(a:firstline))
    " 获取缩进值备用
    let lines = getline(a:firstline, lastline)
    let lines = map(lines, 'substitute(v:val, "^\\_s\\+\\|\\_s\\+$", "", "g")')
    " 删除行首行尾空格和空行
    let string = join(lines, ' or ')
    " 使用or连接多行
    let string = substitute(string, '\(\s*\<or\>\s*\)\{2,}', ' or ', 'g')
    silent execute a:firstline . "," . lastline . 'delete'
    call append(a:firstline - 1, _indent . string)
    call setpos(".", save_cursor)
    " silent execute "'q"
endfunction

function! SplitLineWithOR() range
    let save_cursor = getpos(".")
    let _indent = repeat(" ", indent(a:firstline))
    " 获取缩进值备用
    let string = join(getline(a:firstline, a:lastline), ' or ')
    " 使用or连接多行
    let string = substitute(string, '^\_s\+\|\_s\+$', '', 'g')
    " 删除行首行尾空格和空行
    let lines = split(string, '\(\s*\<or\>\s*\)\+')
    " 使用or分割字符串
    let lines = map(lines, '_indent . v:val')
    " 给每一行都加上缩进
    silent execute a:firstline . "," . a:lastline . 'delete'
    " 删除用or分割前的多行
    call append(a:firstline - 1, lines)
    " 在原来的位置增加用or分割后的多行
    call setpos(".", save_cursor)
    echom len(lines) . " keywords found."
    unlet _indent
    unlet lines
    unlet string
    " 释放过程中用到的三个变量
endfunction

function! SortIPC() range
    execute "normal! mq"
    " 保存当前光标的位置，恢复用
    let _indent = repeat(" ", indent(a:firstline))
    " 获取缩进长度并转换为对应长度的字符串备用
    let lines = getline(a:firstline, a:lastline)
    " 获取选中的内容，结果是一个列表。
    let string = join(lines, ' or ')
    " 将选中的内容的字符串列表连接成一个字符串
    let string = substitute(string, '^\s\+\|\s\+$', '', 'g')
    " 去除行首行尾的多余空格
    let lines = sort(List2set(split(string, '\(\s*\<or\>\s*\)\+')))
    " 将长字符串使用 or 分割成列表，然后排序，千万不要改成空格来分割，因为关键词中有可能出现空格
    echom len(lines) . " IPC keywords found."
    let string = _indent . join(lines, ' or ')
    " 将列表使用or连接起来，将加上之前保存的缩进量，形成新的行
    silent execute setline(line('.'), string)
    " 使用setline函数替换原来的行（不需要先添加行，再用delete删除行）
    " silent delete"可以用这条命令删除行，这里并不需要
    if a:firstline < a:lastline
        silent execute (a:firstline + 1) . "delete" . (a:lastline - a:firstline)
    endif
    unlet _indent
    unlet lines
    unlet string
    " 释放过程中用到的三个变量
    execute "normal! `q"
    " 恢复光标位置
endfunction

function! List2set(lst)
    let temp_dict = {}
    for i in a:lst
        let temp_dict[i] = v:true
    endfor
    return keys(temp_dict)
endfunction

" let lst = [1, 2, 1, 3]
" echom lst
" echo List2set(lst)
" 列表不能用echom显示，只能用echo，囧

function! ClearData()
    " 此函数用于将从incoPat的筛选器中复制出的发明人变换成检索式，查全查准的时候有用
    let lines = getline(1, "$")
    call filter(lines, 'v:val !~ "^\\s*\\d\\|隐藏\\|不公开\\|^\\s*$"')
    " 过滤不需要的行
    call map(lines, 'substitute(v:val, "^[ \"]*\\|[ \"]*$", "\"", "g")')
    " 删除行首行尾空格并在前后都加上引号
    execute "normal! ggdG"
    " 清空缓冲区
    call setline(1, "intt = (" . join(lines, ' or ') . ")")
    " 将多个发明人or起来然后再括起来并加上发明人字段
    call setpos(".", [0, 1, 1, 0])
    " 将光标旋转在首行首列
endfunction

function! GetElements() range
    " 此函数用来从检索式中抽取检索要素
    let lines = getline(a:firstline, a:lastline)
    let lines = map(lines, 'substitute(v:val, "\\(ab\\|ab-otlang\\|ab-ts\\|abo\\|ad\\|adm\\|ady\\|aee\\|aeenor\\|agc\\|all\\|an\\|ann\\|aor\\|ap\\|ap-add\\|ap-country\\|ap-or\\|ap-ot\\|ap-otadd\\|ap-pc\\|ap-province\\|ap-ts\\|ap-type\\|apnor\\|assign-city\\|assign-country\\|assign-date\\|assign-flag\\|assign-party\\|assign-state\\|assign-text\\|assignee-add\\|assignee-cadd\\|assignyear\\|at\\|at-add\\|at-city\\|at-country\\|at-state\\|auth\\|bclas1\\|bclas2\\|bclas3\\|cf\\|cfn\\|city\\|claim\\|claim-en\\|claim-or\\|claim-ts\\|class\\|cn-dc\\|county\\|cp-dc\\|cpc\\|cpc-class\\|cpc-group\\|cpc-section\\|cpc-subclass\\|cpc-subgroup\\|ct\\|ct-ad\\|ct-ap\\|ct-auth\\|ct-code\\|ct-no\\|ct-pd\\|ct-times\\|ctfw\\|ctfw-ad\\|ctfw-ap\\|ctfw-auth\\|ctfw-no\\|ctfw-pd\\|ctfw-times\\|ctnp\\|ctyear\\|customs-flag\\|des\\|des-or\\|doc-dc\\|ecd\\|ecla\\|ecla-class\\|ecla-group\\|ecla-section\\|ecla-subclass\\|ecla-subgroup\\|ex\\|ex-time\\|expiry-date\\|fa-country\\|fam-dc\\|fc-dc\\|fct\\|fct-ap\\|fct-times\\|fctfw\\|fctfw-ap\\|fctfw-times\\|fi\\|filing-lang\\|ft\\|full\\|grant-date\\|ian\\|if\\|ifn\\|in\\|in-add\\|in-ap\\|in-city\\|in-country\\|in-state\\|ipc\\|ipc-class\\|ipc-group\\|ipc-main\\|ipc-section\\|ipc-subclass\\|ipc-subgroup\\|ipcm-class\\|ipcm-group\\|ipcmaintt\\|ipcm-section\\|ipcm-subclass\\|ipn\\|lawtxt\\|lee\\|lee-current\\|lg\\|lgc\\|lgd\\|lge\\|lgf\\|lgi-case\\|lgi-court\\|lgi-date\\|lgi-defendant\\|lgi-firm\\|lgi-flag\\|lgi-judge\\|lgi-no\\|lgi-party\\|lgi-plantiff\\|lgi-region\\|lgi-text\\|lgi-ti\\|lgi-type\\|lgiyear\\|licence-flag\\|license-cs\\|license-date\\|license-no\\|license-sd\\|license-stage\\|license-td\\|license-type\\|licenseyear\\|loc\\|lor\\|mf\\|mfn\\|no-claim\\|number\\|page\\|patent-life\\|patentee\\|patenteenor\\|pc-cn\\|pd\\|pdm\\|pdy\\|pee\\|pee-current\\|pfex-time\\|phc\\|pledge-cd\\|pledge-date\\|pledge-no\\|pledge-rd\\|pledge-stage\\|pledge-term\\|pledge-type\\|pledgeyear\\|plege-flag\\|pn\\|pnc\\|pnk\\|pnn\\|por\\|pr\\|pr-au\\|pr-date\\|prd\\|prn\\|pryear\\|pt\\|pu-date\\|re-ap\\|ree-flag\\|ref-dc\\|reward-level\\|reward-name\\|reward-session\\|ri-ae\\|ri-ap\\|ri-basis\\|ri-date\\|ri-inernal\\|ri-leader\\|ri-me\\|ri-num\\|ri-point\\|ri-text\\|ri-type\\|riyear\\|status\\|status-lite\\|std-company\\|std-etsi\\|std-flag\\|std-num\\|subex-date\\|ti\\|ti-otlang\\|ti-ts\\|tiab\\|tiabc\\|tio\\|uc\\|uc-main\\|vlstar\\|who\\|ap\\|ap-or\\|ap-ot\\|ap-ts\\|apnor\\|aee\\|aor\\|assign-party\\|aeenor\\|ap-otadd\\|in\\|lor\\|lee\\|lgi-party\\|at\\|agc\\|re-ap\\|in-ap\\|ri-me\\|ri-ae\\|ri-leader\\|por\\|pee\\|ex\\|ap-type\\|who\\|patentee\\|patenteenor\\|aptt\\|ap-ortt\\|ap-ottt\\|ap-tstt\\|apnortt\\|aeett\\|aortt\\|assign-partytt\\|aeenortt\\|ap-otaddtt\\|intt\\|lortt\\|leett\\|lgi-partytt\\|attt\\|agctt\\|re-aptt\\|in-aptt\\|ri-mett\\|ri-aett\\|ri-leadertt\\|portt\\|peett\\|extt\\|ap-typett\\|whott\\|patenteett\\|patenteenortt\\)\\s*=", " ", "g")')
    " 删除字段名称
    let lines = map(lines, 'substitute(v:val, "\\c\\s*\\<\\(and\\|or\\|not\\)\\>\\+\\s*", " ", "g")')
    " 删除and or not
    let lines = map(lines, 'substitute(v:val, "\\s*[:：\\[\\]()（）]\\+\\s*", " ", "g")')
    " 删除方括号和圆括号
    let lines = map(lines, 'substitute(v:val, "\\s\\+", " ", "g")')
    " 多个连续的空格替换为单个空格
    let lines = map(lines, 'substitute(v:val, "^\\s\\+\\|\\s\\+$", "", "g")')
    " 删除行首及行尾的空格
    let lines = filter(lines, 'v:val !~ "^\\s*$"')
    " 移除空行
    let @+ = join(lines, "\n")
    " 使用换行符号连接多个行并且复制到系统剪贴板
    echo len(lines) . " 行检索要素已经被复制到剪贴板！"
endfunction
