runtime! plugin/smartword.vim

describe '<Plug>(smartword-w)'
  before
    new
    map <buffer> [w]  <Plug>(smartword-w)
    0 read t/fixtures/multiple-lines.vim
  end

  after
    close!
  end

  context 'combined with the d operator'
    it 'smartly deletes a word followed by non-indented word'
      normal! 2GW
      Expect [line('.'), col('.')] == [2, 8]

      let @- = '...'
      normal d[w]
      Expect [line('.'), col('.'), @-] == [2, 7, '123456']
    end

    it 'smartly deletes a word followed by indented word'
      normal! 1GW
      Expect [line('.'), col('.')] == [1, 11]

      let @- = '...'
      normal d[w]
      Expect [line('.'), col('.'), @-] ==# [1, 10, 'TestFunction']
    end
  end
end
