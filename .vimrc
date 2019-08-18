set number
set hlsearch
set incsearch
set softtabstop =4         " Tab key indents by 4 spaces.
set ts =4
set expandtab
set autoindent
set hidden                 " Switch between buffers without having to save first.
set noshowmode
set cindent
" set cmdheight =2
" 插件列表

call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
" Plug 'tenfyzhong/CompleteParameter.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/asyncrun.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'dense-analysis/ale'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'     " 注释的插件 <leader>cc和<leader>c<space>
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --go-completer' }
Plug 'Shougo/echodoc.vim'
call plug#end()

" ###################################################################
" lightline

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'helloworld' ] ]
      \ },
      \ 'component': {
      \   'helloworld': 'I am writing shit...'
      \ },
      \ }

set laststatus=2
" ###################################################################
" ctags
set tags=./.tags;,.tags
" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
   endif
" ###########################################################

" asyncrun

let g:asyncrun_rootmarks = ['.svn', '.git', '.root', '_darcs', 'build.xml']
" 自动打开 quickfix window ，高度为 6
let g:asyncrun_open = 6

" 任务结束时候响铃提醒
let g:asyncrun_bell = 1

" 设置 F10 打开/关闭 Quickfix 窗口
nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>

" 设置F7编译整个项目，注意makefile的目录，可以自行修改
nnoremap <silent> <F7> :AsyncRun -cwd=<root>/src make <cr>
" ###########################################################

" ALE
let g:ale_linters_explicit = 1
let g:ale_linters = {
  \   'csh': ['shell'],
  \   'zsh': ['shell'],
  \   'go': ['gofmt', 'golint'],
  \   'python': ['flake8', 'mypy', 'pylint'],
  \   'c': ['gcc', 'cppcheck'],
  \   'cpp': ['gcc', 'cppcheck'],
  \   'text': [],
  \}
let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:airline#extensions#ale#enabled = 1

let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''

" ###########################################################
" YouCompleteMe
let g:ycm_global_ycm_extra_conf='~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1
let g:ycm_key_invoke_completion = '<c-z>'                    " 使用 Ctrl+Z 主动触发语义补全
noremap <c-z> <NOP>
set completeopt=menu,menuone

" 修改补全列表配色
highlight PMenu ctermfg=0 ctermbg=242 guifg=black guibg=darkgrey
highlight PMenuSel ctermfg=242 ctermbg=8 guifg=darkgrey guibg=black

" 对指定源文件，输入两个字母后即触发语义补全
let g:ycm_semantic_triggers =  {
           \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
           \ 'cs,lua,javascript': ['re!\w{2}'],
           \ }

let g:ycm_filetype_whitelist = { 
            \ "c":1,
            \ "cpp":1, 
            \ "go":1,
            \ "python":1,
            \ "sh":1,
            \ "zsh":1,
            \ }

let g:ycm_filetype_blacklist = {
        \ 'markdown' : 1,
        \ 'text' : 1,
        \ 'pandoc' : 1,
        \ 'infolog' : 1,
        \}
" ###########################################################

" LeaderF
let g:Lf_ShortcutF = '<c-p>'
let g:Lf_ShortcutB = '<m-n>'
noremap <c-n> :LeaderfMru<cr>
" 设置F2显示本文件的函数列表，这里Vim映射Alt键不成功，所以自己改成F2
noremap <F2> :LeaderfFunction!<cr>
noremap <m-n> :LeaderfBuffer<cr>
noremap <m-m> :LeaderfTag<cr>
let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_WindowHeight = 0.30
let g:Lf_CacheDirectory = expand('~/.vim/cache')
let g:Lf_ShowRelativePath = 0
let g:Lf_HideHelp = 1
let g:Lf_StlColorscheme = 'powerline'
let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}

" ###########################################################
" nerdtree

noremap <F3> :NERDTreeToggle<cr>
" ###########################################################
" echodoc
let g:echodoc_enable_at_startup = 1

" ###########################################################
" CompleteParameter
" inoremap <silent><expr> ( complete_parameter#pre_complete("()")
" smap <c-j> <Plug>(complete_parameter#goto_next_parameter)
" imap <c-j> <Plug>(complete_parameter#goto_next_parameter)
" smap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
" imap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
