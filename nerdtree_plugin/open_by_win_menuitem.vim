"shove this in ~/.vim/nerdtree_plugin/grep_menuitem.vim
"
" This is nerdtree menu item plugin.
" Add 'o' menu items to open selected dir/file.
" 'o' : (Windows only) open directory/file by file extension association in Windows.
"       if directory is selected, open by explorer.
"
" Originally written by scrooloose
" (http://gist.github.com/205807)

if exists("g:loaded_nerdtree_open_by_win_menuitem")
    finish
endif
let g:loaded_nerdtree_open_by_win_menuitem = 1

call NERDTreeAddMenuItem({
            \ 'text': '(o)pen the current node with windows association',
            \ 'shortcut': 'o'
            \ , 'callback': 'NERDTreeExecuteFileWin32'})

" FUNCTION: NERDTreeExecuteFileWin32() {{{1
function! NERDTreeExecuteFileWin32()
    let treenode = g:NERDTreeFileNode.GetSelected()
    if treenode != {}
        if has("unix")
            " Cygwin user
            let winpath = system("cygpath -w '" . treenode.path.str() . "'")
        else
            let winpath = treenode.path.str()
        endif
        call system("explorer '" . winpath . "'")
    endif
endfunction
