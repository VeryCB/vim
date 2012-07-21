set number
"show line numbers
set nocompatible

filetype plugin indent on
"allow plugin and indent function

syntax on
"syntax highlight

set guifont=Monaco:h12

"set transparency=15

colorscheme molokai

" ######### VimWiki 写作助手 ######### "

" 使用鼠标映射

let g:vimwiki_use_mouse = 1

" 不要将驼峰式词组作为 Wiki 词条
let g:vimwiki_camel_case = 0

let g:vimwiki_list = [{
\ 'path': '~/dropbox/develop/vimwiki/',
\ 'path_html': '~/dropbox/develop/octopress/source/wiki/',
\ 'auto_export': 1}]
