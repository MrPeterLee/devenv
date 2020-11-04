function! myspacevim#before() abort
  " Script that dominates SpaceVim settings
  augroup custom_autocmd
    au!
    " au FileType text,md,markdown setlocal textwidth=78
    " au FileType text,md,markdown setlocal wrap
    au BufRead,BufNewFile *.txt,*.tex,*.md set wrap linebreak nolist textwidth=0 wrapmargin=0

  augroup END

endfunction

function! myspacevim#after() abort
  " SpaceVim settings dominates the below settings

  " =========== SpaceVim General Settings ===========
  " Copy to remote clipboard
  set clipboard=unnamed
  vnoremap <Leader>y :'<,'>write! >> /tmp/vim_clipboard.tempfile <enter> <bar> : !transfer_tempfile_to_local_clipboard <enter> <bar> : !rm -f /temp/vim_clipboard.tempfile <enter>

  " If you want to add custom SPC prefix key bindings, you can add them to bootstrap function, be sure the key bindings are not used in SpaceVim.
  " call SpaceVim#custom#SPCGroupName(['G'], '+TestGroup')
  " call SpaceVim#custom#SPC('nore', ['y'], 'echom 1', 'echomessage 1', 1)

  " =========== Tmux Navigator Settings ===========
  let g:SimpylFold_docstring_preview = 1

  " =========== Python iSort Settings ===========
  let g:vim_isort_config_overrides = {
  \ 'include_trailing_comma': 1, 'multi_line_output': 3}
  let g:vim_isort_python_version = 'python3'
  let g:vim_isort_map = ''

  " =========== Ultisnips Settings ===========
    "ultisnips
  let g:snips_author = "Peter Lee"
  let g:snips_email = "mr.peter.lee@finclab.com"
  let g:snips_github = "https://github.com/mrpeterlee"

  let g:UltiSnipsExpandTrigger               <c-7>
  let g:UltiSnipsListSnippets                <c-8>
  let g:UltiSnipsJumpForwardTrigger          <c-9>
  let g:UltiSnipsJumpBackwardTrigger         <c-0>

  " =========== Vim-Tmux Navigator Settings ===========
  let g:tmux_navigator_no_mappings = 1
  " Move between Vim windows and Tmux panes
  " - It requires the corresponding configuration into Tmux.
  " - Check it at my .tmux.conf from my dotfiles repository.
  " - URL: https://github.com/gerardbm/dotfiles/blob/master/tmux/.tmux.conf
  " - Plugin required: https://github.com/christoomey/vim-tmux-navigator
  " nnoremap <silent> <M-h> :TmuxNavigateLeft<CR>
  " nnoremap <silent> <M-j> :TmuxNavigateDown<CR>
  " nnoremap <silent> <M-k> :TmuxNavigateUp<CR>
  " nnoremap <silent> <M-l> :TmuxNavigateRight<CR>

  " =========== Python Linter Settings ===========
  " Linter - Black
  " let g:neoformat_python_black = {
  "   \ 'exe': 'black',
  "   \ 'stdin': 1,
  "   \ 'args': ['-q', '-'],
  "   \ }
  " let g:neoformat_enabled_python = ['black']

  " Pydocstring
  let g:pydocstring_doq_path = /opt/anaconda/envs/finclab/bin/doq
  let g:pydocstring_formatter = 'sphinx'

  " =========== Github Settings ===========
  " func! myspacevim#before() abort
  let g:github_dashboard = { 'username': 'mrpeterlee', 'password': $github_access_token }
  let g:gista#client#default_username = 'mrpeterlee'

  "set clipboard=unnamed
  " Copy text into the remote clipboard
  " vnoremap <Leader>y "+y<Esc>
  vnoremap <Leader>y :'<,'>write! >> /tmp/vim_clipboard.tempfile <enter> <bar> : !transfer_tempfile_to_local_clipboard <enter> <bar> : !rm -f /tmp/vim_clipboard.tempfile <enter>
  nnoremap <Leader>p "+p

  " Support makefiles as tasks
  function! s:make_tasks() abort
      if filereadable('Makefile')
          let subcmd = filter(readfile('Makefile', ''), "v:val=~#'^.PHONY'")
          if !empty(subcmd)
              let commands = split(subcmd[0])[1:]
              let conf = {}
              for cmd in commands
                  call extend(conf, {
                              \ cmd : {
                              \ 'command': 'make',
                              \ 'args' : [cmd],
                              \ 'isDetected' : 1,
                              \ 'detectedName' : 'make:'
                              \ }
                              \ })
              endfor
              return conf
          else
              return {}
          endif
      else
          return {}
      endif
  endfunction
  call SpaceVim#plugins#tasks#reg_provider(funcref('s:make_tasks'))

  let g:neomake_python_pylint_maker = {
  \ 'args': [
  \ '-d', 'C0103, C0111',
  \ '-f', 'text',
  \ '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg}"',
  \ '-r', 'n'
  \ ],
  \ 'errorformat':
  \ '%A%f:%l:%c:%t: %m,' .
  \ '%A%f:%l: %m,' .
  \ '%A%f:(%l): %m,' .
  \ '%-Z%p^%.%#,' .
  \ '%-G%.%#',
  \ }

  "let g:neomake_python_enabled_makers = ['flake8']
  " let g:neomake_python_enabled_makers = ['flake8']
  " let g:neomake_python_enabled_makers = ['pylint']
  let g:neomake_python_enabled_makers = []

endfunction

