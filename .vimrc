
"文字コードをUTF-8に設定
"
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
" 改行コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac
" □や○文字が崩れる問題を解決
set ambiwidth=double
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd

" 見た目系
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 現在の行を強調表示（縦）
"set cursorcolumn
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
noremap j gj
noremap k gk


" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
"set list listchars=tab:\▸\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
" 行頭でのTab文字の表示幅
set shiftwidth=2

set softtabstop=2

set autoindent


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>
" カーソルの左右移動で行末から次の行の行頭への移動が可能になる
set whichwrap=b,s,h,l,<,>,[,],~


set backspace=indent,eol,start
set clipboard+=unnamed
"set clipboard+=autoselect



" プラグインが実際にインストールされるディレクトリ
let s:dpp_base = expand('~/.cache/dpp')
let s:dpp_src = s:dpp_base .. '/repos/github.com/Shougo/dpp.vim'
let s:denops_src = s:dpp_base .. '/repos/github.com/vim-denops/denops.vim'

" dpp.vim がなければ github から落としてくる
if !isdirectory(s:dpp_src)
  execute '!git clone https://github.com/Shougo/dpp.vim' s:dpp_src
endif
if !isdirectory(s:denops_src)
  execute '!git clone https://github.com/vim-denops/denops.vim' s:denops_src
endif

" ランタイムパスに追加
execute 'set runtimepath^=' .. s:dpp_src
execute 'set runtimepath^=' .. s:denops_src

" Deno設定
let g:denops#deno = '/opt/homebrew/bin/deno'

" dpp設定ディレクトリ
let g:rc_dir = expand('~/.config/dpp')

" dppの設定開始
if dpp#min#load_state(s:dpp_base)
  " configディレクトリ内のTypeScriptファイルを読み込み
  call dpp#make_state(s:dpp_base, g:rc_dir .. '/dpp.ts')
endif

" プラグインの自動インストール
autocmd User DppLoadPost call dpp#check_install()

" 手動インストールコマンド
function! DppInstall() abort
  call dpp#async_ext_action('installer', 'install')
endfunction
command! DppInstall call DppInstall()

" 手動アップデートコマンド  
function! DppUpdate() abort
  call dpp#async_ext_action('installer', 'update')
endfunction
command! DppUpdate call DppUpdate()

filetype indent on
set laststatus=2

if filereadable(expand('~/.config/dpp/config'))
  source ~/.config/dpp/config
endif

let g:indentLine_char = '¦'
" colorscheme molokai
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

syntax on
" 背景色
set background=light

" ライトテーマの設定
if &background == 'light'
  " 利用可能なライトテーマを順番に試す
  silent! colorscheme PaperColor
  if !exists('g:colors_name') || g:colors_name != 'PaperColor'
    silent! colorscheme one
    if !exists('g:colors_name') || g:colors_name != 'one'
      silent! colorscheme base16-default-light
      if !exists('g:colors_name') || g:colors_name !~ 'base16'
        " 最後のフォールバック
        silent! colorscheme shine
      endif
    endif
  endif
endif
