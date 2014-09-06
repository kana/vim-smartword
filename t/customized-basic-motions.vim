runtime! plugin/smartword.vim

function! Repeated(motion)
  let ps = []
  call add(ps, [line('.'), col('.')])
  while !0
    execute 'normal' a:motion
    let p = [line('.'), col('.')]
    if p == ps[-1]
      return ps
    endif
    call add(ps, p)
  endwhile
endfunction

describe 'vim-smartword'
  before
    new
    map     <buffer> [w]                         <Plug>(smartword-w)
    noremap <buffer> <Plug>(smartword-basic-w)   W
    map     <buffer> [b]                         <Plug>(smartword-b)
    noremap <buffer> <Plug>(smartword-basic-b)   B
    map     <buffer> [e]                         <Plug>(smartword-e)
    noremap <buffer> <Plug>(smartword-basic-e)   E
    map     <buffer> [ge]                        <Plug>(smartword-ge)
    noremap <buffer> <Plug>(smartword-basic-ge)  gE
    0 read t/fixtures/sample.txt
  end

  after
    close!
  end

  describe '<Plug>(smartword-basic-w)'
    it 'is used as a basic motion for <Plug>(smartword-w)'
      normal! 1G0
      Expect Repeated('[w]') == [[1, 1], [1, 9], [1, 21], [1, 23]]
    end
  end

  describe '<Plug>(smartword-basic-b)'
    it 'is used as a basic motion for <Plug>(smartword-b)'
      normal! 1G$
      Expect Repeated('[b]') == [[1, 23], [1, 21], [1, 9], [1, 1]]
    end
  end

  describe '<Plug>(smartword-basic-e)'
    it 'is used as a basic motion for <Plug>(smartword-e)'
      normal! 1G0
      Expect Repeated('[e]') == [[1, 1], [1, 7], [1, 23]]
    end
  end

  describe '<Plug>(smartword-basic-ge)'
    it 'is used as a basic motion for <Plug>(smartword-ge)'
      normal! 1G$
      Expect Repeated('[ge]') == [[1, 23], [1, 7], [1, 1]]
    end
  end
end
