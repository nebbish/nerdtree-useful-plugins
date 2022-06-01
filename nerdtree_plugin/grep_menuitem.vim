" My modified version of the gist that was...
"
" originally adapted by masaakif
" (https://gist.github.com/masaakif/414375)
" from what I think was the very original by scrooloose
" (http://gist.github.com/205807)
"
"
"shove this in ~/.vim/nerdtree_plugin/grep_menuitem.vim
"
" Add 'g' menu items to grep under selected directory.
" 'g' : prompts the user to type search pattern under selected dir.
"       use parent directory if file is selected.
"       This uses ':grep'.
"
" For ripgrep user,
"   NERDTreeRipGrepDirectory function is much, much faster. 
"   Requirements:
"   - Ripgrep: https://github.com/BurntSushi/ripgrep
"   - vim-ripgrep: https://github.com/jremmen/vim-ripgrep
"

" NERDTREE ITEM INIT: {{{1
if !exists("g:loaded_nerdtree_grep_menuitem")
    call NERDTreeAddMenuItem({
                \ 'text': '(g)rep directory',
                \ 'shortcut': 'g',
                \ 'callback': 'NERDTreeGrepDirectory' })

    let g:loaded_nerdtree_grep_menuitem = 1
endif
if exists("g:loaded_rg")
    if !exists("g:loaded_nerdtree_ripgrep_menuitem")
        call NERDTreeAddMenuItem({
                    \ 'text': '(r)ipgrep directory',
                    \ 'shortcut': 'r',
                    \ 'callback': 'NERDTreeRipGrepDirectory' })

        let g:loaded_nerdtree_ripgrep_menuitem = 1
    endif
endif

" HELPER FUNC: s:SetShellPipeNoEcho() {{{1
function! s:SetShellPipeNoEcho()
    let old_shellpipe = &shellpipe
    if has('win32')
        "let &shellpipe = '>%s 2>&1'
        let &shellpipe = '>%s 2>nul'
    else
        " NOTE:  this is apparently NOT enough, or not working in my
        "        MacOS/iTerm environment.  In that environment, the
        "        ':grep' command STILL clears the whole screen. :(
        "        this happens even with the 'silent[!]' prefix
        "
        "        however, i still want to keep using 'silent grep!' in
        "        the actual command, and stay in "cooked" mode so the
        "        VIM window stays visible the whole time
        "
        "        so I am enabling the redraw command in the
        "        HandleResults helper function
        "
        " The '&>' is an advanced way in BASH to redirect BOTH stdout/stderr at
        " the same time.  see:  https://ss64.com/bash/syntax-redirection.html
        "let &shellpipe = '&>'
        let &shellpipe = '>%s 2>/dev/null'
    endif
    return l:old_shellpipe
endfunction

" HELPER FUNC: s:HandleResults() {{{1
function! s:HandleResults(failed, pattern, path)
    let hits = len(getqflist())
    if l:hits == 0

        " Is this :redraw necessary/helpful?
        " Does it serve the same purpose as adjusting the termcap codes?
        " why is it only for the no-hits case?
        " does :copen automatically cause a redraw?
        "
        " See the comments in s:SetShellPipeNoEcho() -- this is still helpful
        " in my MacOS/iTerm environment -- AND, it also has to have the '!'
        if has('macunix')
            redraw!
        endif

        if a:failed
			call nerdtree#echo("Grep failed.")
        else
			call nerdtree#echo("No match found for " . a:pattern . " under [" . a:path . "].")
        endif
    elseif l:hits > 1
        "use the previous window to jump to the first search result
        wincmd w
        copen
    endif
endfunction

" FUNCTION: NERDTreeGrepDirectory() {{{1
function! NERDTreeGrepDirectory()
    let dirnode = g:NERDTreeDirNode.GetSelected()

    let pattern = input("Enter the search pattern: ")
    if l:pattern == ''
        call nerdtree#echo("Grep directory aborted.")
        return
    endif

    "a hack for *nix to ensure the grep output isnt echoed in vim

    let old_shellpipe = s:SetShellPipeNoEcho()
    let old_cwd = getcwd()

    " TODO:  investigate the consequences / benefits of clearing the
    "        enter/exit TERMCAP codes
    "        't_ti':  code for entering TERMCAP mode
    "        't_te':  code for exiting TERMCAP mode
    "
    "        see:   :h terminal-info
    "
    "        It *may* be functionally equivalant to just execute
    "        a :redraw when the grep is done
    "        (which is also below, commented out & ready to go)
    "let t_ti_bak = &t_ti
    "let t_te_bak = &t_te
    try
        "set t_ti=
        "set t_te=

        " If the '-n' and '-r' options are in '-nr' order... then when
        " grepprg is set to 'ag', it is still recursive ('-r' is last)
        " (and the '-n' is harmless then for 'ag' - but needed for grep)

        " TODO:  can it work for both AG and GREP if the path is provided to
        "        the command?   If so, we don't have to save & restore the
        "        current directory
        "exec 'silent cd ' . l:dirnode.path.str()

        " Here we check if there is a trailing backslash in the path name
        " If so, it interferes with the double-quotes surrounding the path
        " and we handle that by adding an extra trailing slash (so one will
        " escape the other and neither will escape the final double-quote)
        let patharg = l:dirnode.path.str()
        if patharg =~ '\\$'  " using dbl-quotes here would require:  "\\\\$"
            " Should only happens on windows, and I *think* only when
            " searching from a drive root, print a message if that
            " assumption is wrong
            if l:patharg !~ '^\w:\\$'
                " NOTE:  this kind of error ends up in messages AND allows the
                "        function/operation to continue
                call nerdtree#echoError("Unexpected path value [" . l:patharg . "] needing handling for its trailing slash")
            endif
            let patharg = l:patharg . '\'
        endif

        " TODO:  what is the consequence of escaping (or not escaping) the
        "        special characters '|' and '#' ?
        "exec 'silent grep! -nr ' . l:pattern . ' .'
        "exec 'silent grep! -nr ' . l:pattern . ' "' . l:patharg . '"'

        "exec 'silent grep! -nr ' . escape(l:pattern, '|#') . ' .'
        exec 'silent grep! -nr ' . escape(l:pattern, '|#') . ' "' . l:patharg . '"'
        let failed = 0
    catch
        let failed = 1
    finally
        let &shellpipe = l:old_shellpipe
        "let &t_ti = l:t_ti_bak
        "let &t_te = l:t_te_bak
        exec 'silent cd ' . l:old_cwd
    endtry

    call s:HandleResults(l:failed, l:pattern, l:dirnode.path.str())

endfunction

" FUNCTION: NERDTreeRipGrepDirectory() {{{1
" This is for ripgrep user.
function! NERDTreeRipGrepDirectory()
    let dirnode = g:NERDTreeDirNode.GetSelected()
    let pattern = input("Enter the search pattern/options: ")

    if l:pattern == ''
        call nerdtree#echo("Grep directory aborted.")
        return
    "else
    "    if match(l:pattern, '"') >= 0
    "        let l:pattern = substitute(l:pattern, '"', '\\"', 'g')
    "    endif
    "    let l:pattern = join(['"', l:pattern, '"'], '')
    endif

    let old_shellpipe = s:SetShellPipeNoEcho()
    let old_cwd = getcwd()

    try
        exec 'silent cd ' . l:dirnode.path.str()
        exec 'silent Rg ' . l:pattern .' .'
        let failed = 0
    catch
        let failed = 1
    finally
        let &shellpipe = l:old_shellpipe
        exec 'silent cd '. l:old_cwd
    endtry

    call s:HandleResults(l:failed, l:pattern, l:dirnode.path.str())
endfunction
