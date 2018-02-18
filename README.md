nerdtree-usefule-plugins
========================
This repository has below 2 plugins
1. grep_menuitem.vim
1. open_by_win_menuitem.vim

## grep_menuitem.vim
A really rough integration of `:grep` or `:Rg` with nerdtree. Adds a `'g'` menu item that
prompts the user for a search pattern to use with `:grep`/`:Rg`. `:grep`/`:Rg` is run on the
selected dir (using the parent if a file is selected).

Originally written by [scrooloose](https://gist.github.com/scrooloose/205807),
enhanced by [masaakif](https://gist.github.com/masaakif/414375),
converted to plugin style by [MarSoft](https://github.com/MarSoft/nerdtree-grep-plugin).

#### Requiremnts for ripgrep users
[Ripgrep](https://github.com/BurntSushi/ripgrep)
[vim-ripgrep](https://github.com/jremmen/vim-ripgrep)

## open_by_win_menuitem.vim
Open selected node(file/dir) by file assocition with WindowsOS. Adds a `'o'`menu item that
opens selected file/dir in WindowsOS. If you selected `*.pdf`, the file should be opened by
associated Windows prgramm. If dir is selected, open by Explorer.
This supports WindowsOS and Cygwin.

## Installation

For Pathogen

`git clone https://github.com/masaakif/nerdtree-grep-plugin.git ~/.vim/bundle/nerdtree-grep-plugin`

Now reload `vim`.

For Vundle

```
Plugin 'scrooloose/nerdtree'
Plugin 'masaakif/nerdtree-useful-plugins'
```

For NeoBundle

```
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'masaakif/nerdtree-useful-plugins'
```

For Plug
```
Plug 'scrooloose/nerdtree'
Plug 'masaakif/nerdtree-useful-plugins'
```

For dein
```toml:plugins.toml
[[plugins]]
repo = 'scrooloose/nerdtree`

[[plugins]]
repo = 'masaakif/nerdtree-useful-plugins'
```
