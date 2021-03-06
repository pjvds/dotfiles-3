func! myspacevim#before() abort
  set wrap
  set ignorecase
  set smartcase
  set splitright
  inoremap jj <esc>
  set clipboard+=unnamed

  " highlight search results
  set incsearch

  :set number relativenumber
  " set absolute numbers in insert mode
  :augroup numbertoggle
  :  autocmd!
  :  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  :  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  :augroup END

  " move cursor to the end of the line while in insert mode (ALT+SHIFT+4)
  inoremap <A-$> <C-o>$
  inoremap <A-^> <C-o>^
  inoremap <A-h> <Left>
  inoremap <A-j> <Esc>j
  inoremap <A-k> <Esc>k
  inoremap <A-l> <Right>
  inoremap <A-O> <C-O>O
  inoremap <A-o> <C-o>o

  " jump up/down row on screen instead of line in document
  nmap j gj
  nmap k gk

  " Normal mode
  nnoremap <C-j> :m .+1<CR>==
  nnoremap <C-k> :m .-2<CR>==

  " Insert mode
  inoremap <C-j> <ESC>:m .+1<CR>==gi
  inoremap <C-k> <ESC>:m .-2<CR>==gi

  " Visual mode
  vnoremap <C-j> :m '>+1<CR>gv=gv
  vnoremap <C-k> :m '<-2<CR>gv=gv

  " map s <Plug>(vim-easymotion-s)
  " nnoremap <SPACE> <Plug>(vim-easymotion-s2)
  " map <leader>. <Plug>(vim-easymotion-prefix)
  " let g:EasyMotion_do_mapping = 1

  let g:spacevim_automatic_update = 1

  let g:spacevim_custom_plugins = [
            \ ['pangloss/vim-javascript', {'merged' : 0}],
            \ ['mxw/vim-jsx', {'merged' : 0}],
            \ ['w0rp/ale', {'merged' : 0}],
            \ ['907th/vim-auto-save', {'merged' : 0}],
            \ ['fatih/vim-go', {'merged' : 0}],
            \ ['jodosha/vim-godebug', {'merged' : 0}],
            \ ['Shougo/deoplete.nvim', {'merged' : 0}],
            \ ['zchee/deoplete-go', {'merged' : 0}],
            \ ['majutsushi/tagbar', {'merged' : 0}],
            \ ['mileszs/ack.vim', {'merged' : 0}],
            \ ]

  " When the installation of ack.vim fails, run this command:
  " git clone --config transfer.fsckObjects=false https://github.com/mileszs/ack.vim.git ~/.cache/vimfiles/repos/github.com/mileszs/ack.vim

  " run 'pip3 install neovim' for vim
  " and :GoInstallBinaries
  let g:deoplete#enable_at_startup = 1
  let g:go_auto_sameids = 1
	let g:go_highlight_types = 1
	let g:go_highlight_fields = 1
	let g:go_highlight_functions = 1
	let g:go_highlight_methods = 1
	let g:go_highlight_operators = 1
	let g:go_highlight_build_constraints = 1
	let g:go_highlight_structs = 1
	let g:go_highlight_generate_tags = 1
	let g:go_highlight_extra_types = 1
	let g:go_list_type = "quickfix"
	let g:go_fmt_command = "goimports"
  let g:go_test_show_name=1
  let g:go_term_enabled = 1
  let g:go_auto_type_info = 1
  " 'snakecase' is also supported
  let g:go_addtags_transform = "camelcase"
  let g:go_metalinter_autosave = 0

  au FileType go nmap <leader>t :GoDeclsDir<cr>
  au FileType go nmap <leader><F12> :GoReferrers<cr>
  " alternative for gd
  au FileType go nmap <F12> <Plug>(go-def)

  " jump to next error
  map <C-n> :cnext<CR>
  map <C-m> :cprevious<CR>

  let g:jsx_ext_required = 0 " Allow JSX in normal JS files 

  let g:ale_linters = {
            \   'javascript': ['eslint'],
            \}
  " Run 'yarn global add prettier eslint babel-eslint eslint-plugin-react`' 
  " and (in project directory) 'eslint --init' for this one
  let g:ale_fixers = {'javascript': ['prettier','eslint']}

  let g:ale_lint_on_save = 1
  let g:ale_fix_on_save = 1
  let g:auto_save = 1

  let g:ackprg = 'ag --vimgrep'
  nmap <leader>a :Ack! 

  " close buffer with \bd or :Bclose
  :call InstallBclose()
endf

func! myspacevim#after() abort
  exec "iunmap jk"
endf

function InstallBclose()
  " Delete buffer while keeping window layout (don't close buffer's windows).
  " Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
  if v:version < 700 || exists('loaded_bclose') || &cp
    finish
  endif
  let loaded_bclose = 1
  if !exists('bclose_multiple')
    let g:bclose_multiple = 1
  endif

  " Display an error message.
  function! s:Warn(msg)
    echohl ErrorMsg
    echomsg a:msg
    echohl NONE
  endfunction

  " Command ':Bclose' executes ':bd' to delete buffer in current window.
  " The window will show the alternate buffer (Ctrl-^) if it exists,
  " or the previous buffer (:bp), or a blank buffer if no previous.
  " Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
  " An optional argument can specify which buffer to close (name or number).
  function! s:Bclose(bang, buffer)
    if empty(a:buffer)
      let btarget = bufnr('%')
    elseif a:buffer =~ '^\d\+$'
      let btarget = bufnr(str2nr(a:buffer))
    else
      let btarget = bufnr(a:buffer)
    endif
    if btarget < 0
      call s:Warn('No matching buffer for '.a:buffer)
      return
    endif
    if empty(a:bang) && getbufvar(btarget, '&modified')
      call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
      return
    endif
    " Numbers of windows that view target buffer which we will delete.
    let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
    if !g:bclose_multiple && len(wnums) > 1
      call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
      return
    endif
    let wcurrent = winnr()
    for w in wnums
      execute w.'wincmd w'
      let prevbuf = bufnr('#')
      if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
        buffer #
      else
        bprevious
      endif
      if btarget == bufnr('%')
        " Numbers of listed buffers which are not the target to be deleted.
        let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
        " Listed, not target, and not displayed.
        let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
        " Take the first buffer, if any (could be more intelligent).
        let bjump = (bhidden + blisted + [-1])[0]
        if bjump > 0
          execute 'buffer '.bjump
        else
          execute 'enew'.a:bang
        endif
      endif
    endfor
    execute 'bdelete'.a:bang.' '.btarget
    execute wcurrent.'wincmd w'
  endfunction
  command! -bang -complete=buffer -nargs=? Bclose call s:Bclose('<bang>', '<args>')
  nnoremap <silent> <Leader>bd :Bclose<CR>
endfunction
