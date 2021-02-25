let s:fixture = expand('%:p:h').'/fixture.txt'

function SetUp()
  execute 'edit' s:fixture
endfunction

function TearDown()
  bdelete!
endfunction


function Test_first_match()
  execute "normal! /at\<CR>"
  doautocmd CursorMoved

  let matches = getmatches()
  call assert_equal(1, len(matches))
  call assert_equal('PmenuSel', matches[0].group)
  call assert_equal([1,6,2], matches[0].pos1)

  " move out of match
  normal! h
  doautocmd CursorMoved
  call assert_equal([], getmatches())

  " move back in to match
  normal! l
  doautocmd CursorMoved
  call assert_equal(1, len(getmatches()))
endfunction


function Test_cursor_anywhere_in_match()
  execute "normal! /at/e\<CR>"
  doautocmd CursorMoved

  let matches = getmatches()
  call assert_equal(1, len(matches))
  call assert_equal('PmenuSel', matches[0].group)
  call assert_equal([1,6,2], matches[0].pos1)
endfunction


function Test_second_match_in_a_line()
  execute "normal! /at\<CR>n"
  doautocmd CursorMoved

  let matches = getmatches()
  call assert_equal(1, len(matches))
  call assert_equal('PmenuSel', matches[0].group)
  call assert_equal([1,10,2], matches[0].pos1)
endfunction


function Test_clears_matches_in_correct_window()
  execute "normal! /at\<CR>"
  doautocmd CursorMoved
  let win = win_getid()

  split
  doautocmd CursorMoved

  call assert_equal(0, len(getmatches(win)))
endfunction


function Test_deletion_of_line_with_match()
  execute "normal! /at\<CR>"
  doautocmd CursorMoved

  1d
  doautocmd CursorMoved

  " no error thrown
endfunction


function Test_deletion_of_window_with_match()
  execute "normal! /at\<CR>"
  doautocmd CursorMoved
  let win = winnr()

  split
  wincmd j
  call assert_notequal(win, winnr())  " sanity
  doautocmd CursorMoved

  execute win.'wincmd c'
  doautocmd CursorMoved

  " no error thrown
endfunction


function Test_matches_cleared_by_someone_else()
  execute "normal! /at\<CR>"
  doautocmd CursorMoved
  call assert_equal(1, len(getmatches()))

  call clearmatches()
  doautocmd CursorMoved

  " no error thrown
endfunction
