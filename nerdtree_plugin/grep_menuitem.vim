"shove this in ~/.vim/nerdtree_plugin/grep_menuitem.vim
"
"A really rough integration of :grep with nerdtree. Adds a 'g' menu item that
"prompts the user for a search pattern to use with :grep. :grep is run on the
"selected dir (using the parent if a file is selected)
"
" 'r' : ripgrep under selected dir.
"       This is for ripgrep user. Ripgrep is much, much faster.
"       Requirements:
"       - Ripgrep: https://github.com/BurntSushi/ripgrep
"       - vim-ripgrep: https://github.com/jremmen/vim-ripgrep
"
" Originally written by scrooloose
" (http://gist.github.com/205807)

if exists("g:loaded_nerdtree_grep_menuitem")
    finish
endif
let g:loaded_nerdtree_grep_menuitem = 1

call NERDTreeAddMenuItem({
            \ 'text': '(g)rep directory',
            \ 'shortcut': 'g',
            \ 'callback': 'NERDTreeGrep' })

call NERDTreeAddMenuItem({
            \ 'text': '(r)ipgrep directory',
            \ 'shortcut': 'r',
            \ 'callback': 'NERDTreeRipGrepDirectory' })

" FUNCTION: NERDTreeGrep() {{{1
function! NERDTreeGrep()
    let dirnode = g:NERDTreeDirNode.GetSelected()

    let pattern = input("Enter the search pattern: ")
    if pattern == ''
        echo 'Aborted'
        return
    endif

    "use the previous window to jump to the first search result
    wincmd w

    "a hack for *nix to make sure the output of "grep" isnt echoed in vim
    let old_shellpipe = &shellpipe
    let &shellpipe='&>'

    try
        exec 'silent cd ' . dirnode.path.str()
        exec 'silent grep -rn ' . pattern . ' .'
        " exec 'silent grep -rn ' . pattern . ' ' . dirnode.path.str()
    finally
        let &shellpipe = old_shellpipe
    endtry

    let hits = len(getqflist())
    if hits == 0
        echo "No hits"
    elseif hits > 1
        copen
        " echo "Multiple hits. Jumping to first, use :copen to see them all."
    endif

endfunction

" FUNCTION: NERDTreeRipGrepDirectory() {{{1
function! NERDTreeRipGrepDirectory()
    let dirnode = g:NERDTreeDirNode.GetSelected()
    let pattern = input("Enter the search pattern/options: ")

    if pattern == ''
        call nedtree#echo("Grep directory aborted.")
        return
    endif

    wincmd w
    let old_shellpipe = &shellpipe
    let &shellpipe='&>'

    try
        let s:current_dir = expand("%:p:h")
        exec 'silent cd ' . dirnode.path.str()
        exec 'silent Rg ' . pattern .' .'
    finally
        let &shellpipe = old_shellpipe
        exec 'silent cd '. s:current_dir
    endtry

    let hits = len(getqflist())
    if hits == 0
        echo "No hits"
    elseif hits > 1
        copen
    endif
endfunction
