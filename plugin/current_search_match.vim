if exists('g:loaded_current_search_match') || !exists('*matchstrpos')
  finish
endif
let g:loaded_current_search_match = 1


let g:current_search_match = get(g:, 'current_search_match', 'PmenuSel')
let s:pos = []
let s:match = 0
let s:nomatch = [0, 0]


function! s:is_highlighting_search()
  return &hlsearch && v:hlsearch
endfunction


function! s:delete_current_match()
  if !s:match | return | endif
  let winid = s:pos[3]
  if winbufnr(winid) == -1 | return | endif
  call matchdelete(s:match, winid)
endfunction


" Returns [start, stop] if the cursor is in a search match, where start and
" stop are column numbers, or s:nomatch if the cursor is not in a search match.
"
" Note: for matchstrpos() (from docs for match()):
"
"   The 'ignorecase' option is used to set the ignore-caseness of
"   the pattern.  'smartcase' is NOT used.  The matching is always
"   done like 'magic' is set and 'cpoptions' is empty.
"
function! s:cursor_in_search_match(...)
  if !s:is_highlighting_search() | return s:nomatch | endif
  let [match, start, stop] = matchstrpos(getline('.'), @/, (a:0 ? a:1 : 0))
  if empty(match) | return s:nomatch | endif
  let col = getcurpos()[2]
  if col <= start | return s:nomatch | endif
  if col <= stop  | return [start, stop] | endif
  return s:cursor_in_search_match(stop)
endfunction


function! s:update_search_match()
  let [start, stop] = s:cursor_in_search_match()
  if [start, stop] != s:nomatch
    let line = line('.')
    let window = win_getid()
    if s:pos != [start, stop, line, window]
      call s:delete_current_match()
      let s:match = matchaddpos(g:current_search_match, [[line, start+1, stop-start]])
      let s:pos = [start, stop, line, window]
    endif
  else
    call s:delete_current_match()
    let s:match = 0
    let s:pos = []
  endif
endfunction


augroup current_search_match
  autocmd!
  autocmd CursorMoved * call s:update_search_match()
augroup END
