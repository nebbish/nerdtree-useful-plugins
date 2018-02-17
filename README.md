nerdtree-grep-plugin
====================

A really rough integration of `:grep` with nerdtree. Adds a `'g'` menu item that
prompts the user for a search pattern to use with `:grep`. `:grep` is run on the
selected dir (using the parent if a file is selected).

Originally written by [scrooloose](https://gist.github.com/scrooloose/205807),
enhanced by [masaakif](https://gist.github.com/masaakif/414375),
converted to plugin style by [MarSoft](https://github.com/MarSoft/nerdtree-grep-plugin).

## Added below new features.
1. Ripgrep supported. Menu item is 'r'. Windows __NOT__ supported.
1. Open file/dir by file association and extention in Windows. Menu item is 'o'.
   (Cygwin supported)

## Installation

For Pathogen

`git clone https://github.com/masaakif/nerdtree-grep-plugin.git ~/.vim/bundle/nerdtree-grep-plugin`

Now reload `vim`.

For Vundle

```
Plugin 'scrooloose/nerdtree'
Plugin 'MarSoft/nerdtree-grep-plugin'
```

For NeoBundle

```
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'MarSoft/nerdtree-grep-plugin'
```

For Plug
```
Plug 'scrooloose/nerdtree'
Plug 'MarSoft/nerdtree-grep-plugin'
```


