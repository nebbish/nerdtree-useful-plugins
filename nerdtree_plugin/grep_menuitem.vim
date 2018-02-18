"shove this in ~/.vim/nerdtree_plugin/grep_menuitem.vim
"
" A really rough integration of :grep with nerdtree. Adds a 'g' menu item that
" prompts the user for a search pattern to use with :grep. :grep is run on the
" selected dir (using the parent if a file is selected)
"
" This version supports ripgrep. Ripgrep is much, much faster version of grep.
" Requirements:
" - Ripgrep: https://github.com/BurntSushi/ripgrep
" - vim-ripgrep: https://github.com/jremmen/vim-ripgrep
"
" Originally written by scrooloose
" (http://gist.github.com/205807)

if exists("g:loaded_nerdtree_grep_menuitem")
    finish
endif
let g:loaded_nerdtree_grep_menuitem = 1

if exists("g:loaded_rg")
  " Doesn't work. Maybe, because of loading order of plugins...
  let s:text = '(g)rep directory by Ripgrep'
else
  let s:text = '(g)rep directory'
endif

call NERDTreeAddMenuItem({
            \ 'text': s:text,
            \ 'shortcut': 'g',
            \ 'callback': 'NERDTreeGrepDirectory' })

" FUNCTION: NERDTreeGrepDirectory() {{{1
function! NERDTreeGrepDirectory()
    let l:dirnode = g:NERDTreeDirNode.GetSelected()

    let l:pattern = input("Enter the search pattern: ")
    if l:pattern == ''
        echo 'Grep aborted.'
        return
    endif

    "use the previous window to jump to the first search result
    wincmd w

    "a hack for *nix to make sure the output of "grep" isnt echoed in vim
    let l:old_shellpipe = &shellpipe
    if has("win32unix") || has("unix")
    	let &shellpipe='&>'
    endif

    try
        let l:current_dir = expand("%:p:h")
        exec 'silent cd ' . l:dirnode.path.str()
        if exists("g:loaded_rg")
            exec 'silent Rg ' . l:pattern . ' .'
        else
            exec 'silent vimgrep -rn ' . l:pattern . ' .'
        endif
    catch
        let l:failed = 1
    finally
        let &shellpipe = l:old_shellpipe
        exec 'silent cd '. l:current_dir
    endtry

    let l:hits = len(getqflist())
    if l:hits == 0
	if exists("l:failed")
	    "call nerdtree#echo("Grep failed.")
	else
            "call nerdtree#echo("No match found for '" . l:pattern . "'.")
	endif
    elseif hits > 1
        copen
    endif

endfunction
