" smartword - Smart motions on words
" Version: 0.1.1
" Copyright (C) 2008-2015 Kana Natsuno <http://whileimautomaton.net/>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Interface  "{{{1
function! smartword#move(motion_command, mode)  "{{{2
  let given_count = v:count1  " This count is reset by the following setup.

  let exclusive_adjustment_p = 0
  if a:mode ==# 'o' && (a:motion_command ==# 'e' || a:motion_command ==# 'ge')
    if exists('v:motion_force')  " if it's possible to check o_v and others:
      if v:motion_force == ''
        " inclusive
        normal! v
      elseif v:motion_force ==# 'v'
        " User-defined motion is always exclusive and o_v forces it inclusve.
        " So here use Visual mode to behave this motion as an exclusive one.
        normal! v
        let exclusive_adjustment_p = !0
      else  " v:motion_force ==# 'V' || v:motion_force ==# "\<C-v>"
        " linewise or blockwise
        " -- do nothing because o_V or o_CTRL-V will override the motion type.
      endif
    else  " if it's not possible:
      " inclusive -- the same as the default style of "e" and "ge".
      " BUGS: o_v and others are ignored.
      normal! v
    endif
  endif
  if a:mode == 'v'
    normal! gv
  endif

  call s:move(a:motion_command, a:mode, given_count)

  if exclusive_adjustment_p
    execute "normal! \<Esc>"
    if getpos("'<") == getpos("'>")  " no movement - select empty area.
      " FIXME: But how to select nothing?  Because o_v was given, so at least
      " 1 character will be the target of the pending operator.
    else
      let original_whichwrap = &whichwrap
        set whichwrap=h
        normal! `>
        normal! h
        if col('.') == col('$')  " FIXME: 'virtualedit' with onemore
          normal! h
        endif
        if a:motion_command ==# 'ge'
          " 'ge' is backward motion,
          " so that it's necessary to specify the target text in this way.
          normal! v`<
        endif
      let &whichwrap = original_whichwrap
    endif
  endif
endfunction








" Misc.  "{{{1
function! s:current_char(pos)  "{{{2
  return getline(a:pos[1])[a:pos[2] - 1]
endfunction




function! s:move(motion_command, mode, times)  "{{{2
  call s:_move(a:motion_command, a:mode, a:times)
  if &selection ==# 'exclusive'
  \  && a:motion_command ==# 'e'
  \  && (a:mode ==# 'v' || a:mode ==# 'o')
    normal! l
  endif
  if &selection ==# 'exclusive'
  \  && a:motion_command ==# 'ge'
  \  && a:mode ==# 'o'
    normal! ol
  endif
endfunction

function! s:_move(motion_command, mode, times)
  let firstpos = getpos('.')
  let newpos = firstpos

  for i in range(a:times)
    let lastiterpos = newpos
    while !0
      let lastpos = newpos

      execute 'normal' "\<Plug>(smartword-basic-" . a:motion_command . ')'
      if &selection ==# 'exclusive'
      \  && a:motion_command ==# 'e'
      \  && (a:mode ==# 'v' || a:mode ==# 'o')
        normal! h
      endif
      let newpos = getpos('.')

      if s:current_char(newpos) =~# '\k'
        break
      endif
      if lastpos == newpos  " No more word - stop.
        return
      endif
    endwhile
  endfor

  " `dw` is equivalent to `vwhd` in most of situations.  But there is an
  " exception.  If `w` moves the cursor to another line, it acts as `$`.
  " Suppose that the current buffer contains the following text:
  "
  "     1|foo bar
  "     2|  baz
  "     3|qux
  "
  " Typing `w` on "bar" moves the cursor to "baz".
  " But `dw` on "bar" deletes only "bar" instead of "bar\n  ".
  " The same can be said for other operators.
  "
  " vim-smartword tries emulating this exception if necessary.
  if a:motion_command ==# 'w' && a:mode == 'o' && lastiterpos[1] != newpos[1]
    " Here we have to use `$` to emulate the exceptional behavior of `dw`.
    " Though `$` is an inclusive motion, this function is executed in
    " a context of `:` in Operator-pending mode, and a resulting motion by
    " this function is treated as exclusive.  So that we have to use also `v`
    " to target a proper region.
    call setpos('.', firstpos)
    normal! v
    call setpos('.', lastiterpos)
    normal! $h
  endif

  return
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
