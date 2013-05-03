" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" ========== General Config ==========

" show line number
set number

" highlight current line
set cursorline

" ignore case when searching
set ignorecase

" use dot change tab spaces
set list
set listchars=tab:>.,trail:.

" indent format
set sw=4
set ts=4
set sts=4
set et
set sta

" highlight search result
set hlsearch

" tell me where the cursor is located in the file
set ruler

" encoding
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936

" store lots of :cmdline history
set history=1000

" show current mode down the bottom
set showmode

" reload files changed outside vim
set autoread

" turn off swap files
set noswapfile
set nobackup
set nowb

"syntax highlight
syntax on

set guifont=Monaco:h12

" ========== Plugin ==========

" Vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

Bundle "mattn/zencoding-vim"
Bundle "msanders/snipmate.vim"
Bundle "kevinw/pyflakes-vim"
Bundle "kien/ctrlp.vim"
Bundle "vim-scripts/vimwiki"
Bundle "pangloss/vim-javascript"
Bundle "tomasr/molokai"
Bundle "scrooloose/nerdtree"

colorscheme molokai

"allow plugin and indent function
filetype plugin indent on

" Vimwiki
" 使用鼠标映射
let g:vimwiki_use_mouse = 1
" 不要将驼峰式词组作为 Wiki 词条
let g:vimwiki_camel_case = 0
let g:vimwiki_list = [{
\ 'path': '~/dropbox/develop/vimwiki/',
\ 'path_html': '~/dropbox/develop/octopress/source/wiki/',
\ 'auto_export': 1}]

" F10 for nerdtree
nnoremap <silent> <F10> :NERDTreeToggle<CR>

" ========== Keys ==========

" leader key
let mapleader='\'

" change tabs
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>

" STOP using arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" ######### 自动补全括号、引号 ######### "
inoremap ( <c-r>=OpenPair('(')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap { <c-r>=OpenPair('{')<CR>
inoremap } <c-r>=ClosePair('}')<CR>
inoremap [ <c-r>=OpenPair('[')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
" just for xml document, but need not for now.
"inoremap < <c-r>=OpenPair('<')<CR>
"inoremap > <c-r>=ClosePair('>')<CR>
function! OpenPair(char)
    let PAIRs = {
                \ '{' : '}',
                \ '[' : ']',
                \ '(' : ')',
                \ '<' : '>'
                \}
    if line('$')>2000
        let line = getline('.')

        let txt = strpart(line, col('.')-1)
    else
        let lines = getline(1,line('$'))
        let line=""
        for str in lines
            let line = line . str . "\n"
        endfor

        let blines = getline(line('.')-1, line("$"))
        let txt = strpart(getline("."), col('.')-1)
        for str in blines
            let txt = txt . str . "\n"
        endfor
    endif
    let oL = len(split(line, a:char, 1))-1
    let cL = len(split(line, PAIRs[a:char], 1))-1

    let ol = len(split(txt, a:char, 1))-1
    let cl = len(split(txt, PAIRs[a:char], 1))-1

    if oL>=cL || (oL<cL && ol>=cl)
        return a:char . PAIRs[a:char] . "\<Left>"
    else
        return a:char
    endif
endfunction
function! ClosePair(char)
    if getline('.')[col('.')-1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endf

inoremap ' <c-r>=CompleteQuote("'")<CR>
inoremap " <c-r>=CompleteQuote('"')<CR>
function! CompleteQuote(quote)
    let ql = len(split(getline('.'), a:quote, 1))-1
    let slen = len(split(strpart(getline("."), 0, col(".")-1), a:quote, 1))-1
    let elen = len(split(strpart(getline("."), col(".")-1), a:quote, 1))-1
    let isBefreQuote = getline('.')[col('.') - 1] == a:quote

    if '"'==a:quote && "vim"==&ft && 0==match(strpart(getline('.'), 0, col('.')-1), "^[\t ]*$")
        " for vim comment.
        return a:quote
    elseif "'"==a:quote && 0==match(getline('.')[col('.')-2], "[a-zA-Z0-9]")
        " for Name's Blog.
        return a:quote
    elseif (ql%2)==1
        " a:quote length is odd.
        return a:quote
    elseif ((slen%2)==1 && (elen%2)==1 && !isBefreQuote) || ((slen%2)==0 && (elen%2)==0)
        return a:quote . a:quote . "\<Left>"
    elseif isBefreQuote
        return "\<Right>"
    else
        return a:quote . a:quote . "\<Left>"
    endif
endfunction
