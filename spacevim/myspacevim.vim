func! myspacevim#before() abort

  " =========== Custom SPC Hotkey ===========
  " If you want to add custom SPC prefix key bindings,
  " you can add them to bootstrap function, be sure the key bindings are not used in SpaceVim.
  " call SpaceVim#custom#SPCGroupName(['G'], '+TestGroup')
  " call SpaceVim#custom#SPC('nore', ['y'], 'echom 1', 'echomessage 1', 1)
  " call SpaceVim#custom#SPC('nnoremap', ['='], 'Coclist diagnostics', 'display-lint-error', 0)
  call SpaceVim#custom#SPC('nnoremap', ['='], ':CocList diagnostics<CR>', 'display-lint-error', 0)
  " call SpaceVim#custom#SPCGroupName(['='], '+Formats')
  " call SpaceVim#custom#SPC('nnoremap', ['=', '='], 'gg=G``', 'format-the-buffer', 0)

  " Some trick to copy to ssh local clipboard
  "set clipboard=unnamed
  " Copy text into the remote clipboard
  " vnoremap <Leader>y "+y<Esc>
  vnoremap <Leader>y :'<,'>write! >> /tmp/vim_clipboard.tempfile <enter> <bar> : !transfer_tempfile_to_local_clipboard <enter> <bar> : !rm -f /tmp/vim_clipboard.tempfile <enter>
  nnoremap <Leader>p "+p

endf



func! myspacevim#after() abort
  " Script that dominates SpaceVim settings


  " =========== File Types ===========
  " for this filet types, wrap the text
  augroup custom_autocmd
    au!
    " au FileType text,md,markdown setlocal textwidth=78
    " au FileType text,md,markdown setlocal wrap
    au BufRead,BufNewFile *.txt,*.tex,*.md set wrap linebreak nolist textwidth=0 wrapmargin=0
  augroup END

  " =========== SpaceVim General Settings ===========
  " Copy to remote clipboard
  set clipboard=unnamed
  vnoremap <Leader>y :'<,'>write! >> /tmp/vim_clipboard.tempfile <enter> <bar> : !transfer_tempfile_to_local_clipboard <enter> <bar> : !rm -f /temp/vim_clipboard.tempfile <enter>

  " =========== NerdTree ===========
  let g:NERDTreeQuitOnOpen = 1

  " =========== PyDocString DOQ ===========
  let g:pydocstring_doq_path = '/opt/anaconda/envs/finclab/bin/doq'
  let g:pydocstring_formatter = 'numpy'

  " =========== Tmux Navigator Settings ===========
  " " Preview docstring in fold text
  " let g:SimpylFold_docstring_preview = 0
  " " Fold docstrings
  " let g:SimpylFold_fold_docstring = 1
  " let g:SimpylFold_fold_import = 1
  " " old trailing blank lines
  " let g:SimpylFold_fold_blank = 0

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


  " =========== Pydocstring ===========
  let g:pydocstring_doq_path = '/opt/anaconda/envs/finclab/bin/doq'
  let g:pydocstring_formatter = 'sphinx'

  " =========== Github Settings ===========
  " func! myspacevim#before() abort
  let g:github_dashboard = { 'username': 'mrpeterlee', 'password': $github_access_token }
  let g:gista#client#default_username = 'mrpeterlee'

  " =========== My Settings ===========
  " Use rg instead of grep
  if executable("rg")
      set grepprg=rg\ --vimgrep
  endif


endf
