runtime! plugin/smartword.vim

function! TestMovements(direction, movement_command)
  let cols = []

  new
    call setline(1, ['', '<a href="http://www.vim.org/">www.vim.org</a>', ''])

    if a:direction ==# 'forward'
      normal! 2gg0
    else
      normal! 2gg$
    endif
    while line('.') == 2
      call add(cols, col('.'))
      silent! execute a:movement_command
    endwhile
  close!

  return cols
endfunction

function! TestOperations(direction, operation_command)
  let cols = []

  tabnew
    call setline(1, ['', '<a href="http://www.vim.org/">www.vim.org</a>', ''])

    if a:direction ==# 'forward'
      normal! 2gg0
    else
      normal! 2gg$
    endif
    let last_col = -1
    while line('.') == 2 && col('.') != last_col
      let last_col = col('.')
      call add(cols, [last_col, col("'["), col("']")])
      silent! execute a:operation_command
    endwhile
  tabclose!

  return cols
endfunction

function s:test_cases_for_Normal_mode(selection)
  let &selection = a:selection

  Expect TestMovements('forward', 'normal! w') == [
  \   1, 2, 4, 8, 10,
  \   14, 17, 20, 21, 24,
  \   25, 28, 31, 34, 35,
  \   38, 39, 42, 44, 45
  \ ]
  Expect TestMovements('forward', "normal \<Plug>(smartword-w)") == [
  \   1, 2, 4, 10, 17,
  \   21, 25, 31, 35, 39,
  \   44
  \ ]

  Expect TestMovements('backward', 'normal! b') == [
  \   45, 44, 42, 39, 38,
  \   35, 34, 31, 28, 25,
  \   24, 21, 20, 17, 14,
  \   10, 8, 4, 2, 1
  \ ]
  Expect TestMovements('backward', "normal \<Plug>(smartword-b)") == [
  \   45, 44, 39, 35, 31,
  \   25, 21, 17, 10, 4,
  \   2
  \ ]

  Expect TestMovements('forward', 'normal! e') == [
  \   1, 2, 7, 9, 13,
  \   16, 19, 20, 23, 24,
  \   27, 30, 33, 34, 37,
  \   38, 41, 43, 44, 45
  \ ]
  Expect TestMovements('forward', "normal \<Plug>(smartword-e)") == [
  \   1, 2, 7, 13, 19,
  \   23, 27, 33, 37, 41,
  \   44
  \ ]

  Expect TestMovements('backward', 'normal! ge') == [
  \   45, 44, 43, 41, 38,
  \   37, 34, 33, 30, 27,
  \   24, 23, 20, 19, 16,
  \   13, 9, 7, 2, 1
  \ ]
  Expect TestMovements('backward', "normal \<Plug>(smartword-ge)") == [
  \   45, 44, 41, 37, 33,
  \   27, 23, 19, 13, 7,
  \   2
  \ ]
endfunction

function s:test_cases_for_Visual_mode(selection)
  let &selection = a:selection
  let e_cancel = a:selection ==# 'inclusive' ? 'v' : 'hv'

  Expect TestMovements('forward', 'normal! vwv') == [
  \   1, 2, 4, 8, 10,
  \   14, 17, 20, 21, 24,
  \   25, 28, 31, 34, 35,
  \   38, 39, 42, 44, 45
  \ ]
  Expect TestMovements('forward', "normal v\<Plug>(smartword-w)v") == [
  \   1, 2, 4, 10, 17,
  \   21, 25, 31, 35, 39,
  \   44
  \ ]

  Expect TestMovements('backward', 'normal! vbv') == [
  \   45, 44, 42, 39, 38,
  \   35, 34, 31, 28, 25,
  \   24, 21, 20, 17, 14,
  \   10, 8, 4, 2, 1
  \ ]
  Expect TestMovements('backward', "normal v\<Plug>(smartword-b)v") == [
  \   45, 44, 39, 35, 31,
  \   25, 21, 17, 10, 4,
  \   2
  \ ]

  Expect TestMovements('forward', 'normal! ve'.e_cancel) == [
  \   1, 2, 7, 9, 13,
  \   16, 19, 20, 23, 24,
  \   27, 30, 33, 34, 37,
  \   38, 41, 43, 44, 45
  \ ]
  Expect TestMovements('forward', "normal v\<Plug>(smartword-e)".e_cancel) == [
  \   1, 2, 7, 13, 19,
  \   23, 27, 33, 37, 41,
  \   44
  \ ]

  Expect TestMovements('backward', 'normal! vgev') == [
  \   45, 44, 43, 41, 38,
  \   37, 34, 33, 30, 27,
  \   24, 23, 20, 19, 16,
  \   13, 9, 7, 2, 1
  \ ]
  Expect TestMovements('backward', "normal v\<Plug>(smartword-ge)v") == [
  \   45, 44, 41, 37, 33,
  \   27, 23, 19, 13, 7,
  \   2
  \ ]
endfunction

function s:test_cases_for_Operator_pending_mode(selection)
  let &selection = a:selection

  Expect TestOperations('forward', 'normal! yw`]') == [
  \   [1, 0, 0],
  \   [2, 1, 2],
  \   [4, 2, 4],
  \   [8, 4, 8],
  \   [10, 8, 10],
  \   [14, 10, 14],
  \   [17, 14, 17],
  \   [20, 17, 20],
  \   [21, 20, 21],
  \   [24, 21, 24],
  \   [25, 24, 25],
  \   [28, 25, 28],
  \   [31, 28, 31],
  \   [34, 31, 34],
  \   [35, 34, 35],
  \   [38, 35, 38],
  \   [39, 38, 39],
  \   [42, 39, 42],
  \   [44, 42, 44],
  \   [45, 44, 45],
  \ ]
  Expect TestOperations('forward', "normal y\<Plug>(smartword-w)`]") == [
  \   [1, 0, 0],
  \   [2, 1, 2],
  \   [4, 2, 4],
  \   [10, 4, 10],
  \   [17, 10, 17],
  \   [21, 17, 21],
  \   [25, 21, 25],
  \   [31, 25, 31],
  \   [35, 31, 35],
  \   [39, 35, 39],
  \   [44, 39, 44],
  \   [45, 44, 45],
  \ ]

  Expect TestOperations('backward', 'normal! yb') == [
  \   [45, 0, 0],
  \   [44, 44, 45],
  \   [42, 42, 44],
  \   [39, 39, 42],
  \   [38, 38, 39],
  \   [35, 35, 38],
  \   [34, 34, 35],
  \   [31, 31, 34],
  \   [28, 28, 31],
  \   [25, 25, 28],
  \   [24, 24, 25],
  \   [21, 21, 24],
  \   [20, 20, 21],
  \   [17, 17, 20],
  \   [14, 14, 17],
  \   [10, 10, 14],
  \   [8, 8, 10],
  \   [4, 4, 8],
  \   [2, 2, 4],
  \   [1, 1, 2],
  \ ]
  Expect TestOperations('backward', "normal y\<Plug>(smartword-b)") == [
  \   [45, 0, 0],
  \   [44, 44, 45],
  \   [39, 39, 44],
  \   [35, 35, 39],
  \   [31, 31, 35],
  \   [25, 25, 31],
  \   [21, 21, 25],
  \   [17, 17, 21],
  \   [10, 10, 17],
  \   [4, 4, 10],
  \   [2, 2, 4],
  \ ]

  Expect TestOperations('forward', 'normal! ye`]') == [
  \   [1, 0, 0],
  \   [2, 1, 2],
  \   [7, 2, 7],
  \   [9, 7, 9],
  \   [13, 9, 13],
  \   [16, 13, 16],
  \   [19, 16, 19],
  \   [20, 19, 20],
  \   [23, 20, 23],
  \   [24, 23, 24],
  \   [27, 24, 27],
  \   [30, 27, 30],
  \   [33, 30, 33],
  \   [34, 33, 34],
  \   [37, 34, 37],
  \   [38, 37, 38],
  \   [41, 38, 41],
  \   [43, 41, 43],
  \   [44, 43, 44],
  \   [45, 44, 45],
  \ ]
  Expect TestOperations('forward', "normal y\<Plug>(smartword-e)`]") == [
  \   [1, 0, 0],
  \   [2, 1, 2],
  \   [7, 2, 7],
  \   [13, 7, 13],
  \   [19, 13, 19],
  \   [23, 19, 23],
  \   [27, 23, 27],
  \   [33, 27, 33],
  \   [37, 33, 37],
  \   [41, 37, 41],
  \   [44, 41, 44],
  \ ]

  Expect TestOperations('backward', 'normal! yge') == [
  \   [45, 0, 0],
  \   [44, 44, 45],
  \   [43, 43, 44],
  \   [41, 41, 43],
  \   [38, 38, 41],
  \   [37, 37, 38],
  \   [34, 34, 37],
  \   [33, 33, 34],
  \   [30, 30, 33],
  \   [27, 27, 30],
  \   [24, 24, 27],
  \   [23, 23, 24],
  \   [20, 20, 23],
  \   [19, 19, 20],
  \   [16, 16, 19],
  \   [13, 13, 16],
  \   [9, 9, 13],
  \   [7, 7, 9],
  \   [2, 2, 7],
  \   [1, 1, 2],
  \ ]
  Expect TestOperations('backward', "normal y\<Plug>(smartword-ge)") == [
  \   [45, 0, 0],
  \   [44, 44, 45],
  \   [41, 41, 44],
  \   [37, 37, 41],
  \   [33, 33, 37],
  \   [27, 27, 33],
  \   [23, 23, 27],
  \   [19, 19, 23],
  \   [13, 13, 19],
  \   [7, 7, 13],
  \   [2, 2, 7],
  \ ]
endfunction




describe 'vim-smartinput'
  context 'Normal mode'
    it 'moves the cursor smartly'
      call s:test_cases_for_Normal_mode('inclusive')
      call s:test_cases_for_Normal_mode('exclusive')
    end
  end

  context 'Visual mode'
    it 'moves the cursor smartly'
      call s:test_cases_for_Visual_mode('inclusive')
      call s:test_cases_for_Visual_mode('exclusive')
    end
  end

  context 'Operator-pending mode'
    it 'moves the cursor smartly'
      call s:test_cases_for_Operator_pending_mode('inclusive')
      call s:test_cases_for_Operator_pending_mode('exclusive')
    end
  end
end
