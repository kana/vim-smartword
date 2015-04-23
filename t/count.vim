runtime! plugin/smartword.vim

function! Move(command)
  execute 'normal' a:command
  return [line('.'), col('.')]
endfunction

function! Do(command)
  execute 'normal' a:command
  return @0
endfunction

describe 'vim-smartword'
  before
    new
    map <buffer> [w]  <Plug>(smartword-w)
    map <buffer> [b]  <Plug>(smartword-b)
    map <buffer> [e]  <Plug>(smartword-e)
    map <buffer> [ge]  <Plug>(smartword-ge)
    0 read t/fixtures/multiple-lines.vim
  end

  after
    close!
  end

  describe '<Plug>(smartwod-w)'
    context 'in Normal mode'
      it 'supports count'
        Expect Move('1G[w]') ==# [1, 11]
        Expect Move('1G1[w]') ==# [1, 11]
        Expect Move('1G2[w]') ==# [2, 3]
        Expect Move('1G3[w]') ==# [2, 8]
        Expect Move('1G4[w]') ==# [3, 1]
        Expect Move('1G5[w]') ==# [3, 11]
      end
    end

    context 'in Visual mode'
      it 'supports count'
        Expect Move("1Gv[w]\<Esc>") ==# [1, 11]
        Expect Move("1Gv1[w]\<Esc>") ==# [1, 11]
        Expect Move("1Gv2[w]\<Esc>") ==# [2, 3]
        Expect Move("1Gv3[w]\<Esc>") ==# [2, 8]
        Expect Move("1Gv4[w]\<Esc>") ==# [3, 1]
        Expect Move("1Gv5[w]\<Esc>") ==# [3, 11]
      end
    end

    context 'in Operator-pending mode'
      it 'supports count'
        Expect Do('1Gy[w]') ==# 'function! '
        Expect Do('1Gy1[w]') ==# 'function! '
        Expect Do('1Gy2[w]') ==# 'function! TestFunction'
        Expect Do('1Gy3[w]') ==# "function! TestFunction\n  echo "
        Expect Do('1Gy4[w]') ==# "function! TestFunction\n  echo 123456"
        Expect Do('1Gy5[w]') ==# "function! TestFunction\n  echo 123456\nendfunctio"
      end
    end
  end

  describe '<Plug>(smartwod-b)'
    context 'in Normal mode'
      it 'supports count'
        Expect Move('G$[b]') ==# [3, 1]
        Expect Move('G$1[b]') ==# [3, 1]
        Expect Move('G$2[b]') ==# [2, 8]
        Expect Move('G$3[b]') ==# [2, 3]
        Expect Move('G$4[b]') ==# [1, 11]
        Expect Move('G$5[b]') ==# [1, 1]
      end
    end

    context 'in Visual mode'
      it 'supports count'
        Expect Move("G$v[b]\<Esc>") ==# [3, 1]
        Expect Move("G$v1[b]\<Esc>") ==# [3, 1]
        Expect Move("G$v2[b]\<Esc>") ==# [2, 8]
        Expect Move("G$v3[b]\<Esc>") ==# [2, 3]
        Expect Move("G$v4[b]\<Esc>") ==# [1, 11]
        Expect Move("G$v5[b]\<Esc>") ==# [1, 1]
      end
    end

    context 'in Operator-pending mode'
      it 'supports count'
        Expect Do('G$y[b]') ==# 'endfunctio'
        Expect Do('G$y1[b]') ==# 'endfunctio'
        Expect Do('G$y2[b]') ==# "123456\nendfunctio"
        Expect Do('G$y3[b]') ==# "echo 123456\nendfunctio"
        Expect Do('G$y4[b]') ==# "TestFunction\n  echo 123456\nendfunctio"
        Expect Do('G$y5[b]') ==# "function! TestFunction\n  echo 123456\nendfunctio"
      end
    end
  end

  describe '<Plug>(smartwod-e)'
    context 'in Normal mode'
      it 'supports count'
        Expect Move('1G[e]') ==# [1, 8]
        Expect Move('1G1[e]') ==# [1, 8]
        Expect Move('1G2[e]') ==# [1, 22]
        Expect Move('1G3[e]') ==# [2, 6]
        Expect Move('1G4[e]') ==# [2, 13]
        Expect Move('1G5[e]') ==# [3, 11]
      end
    end

    context 'in Visual mode'
      it 'supports count'
        Expect Move("1Gv[e]\<Esc>") ==# [1, 8]
        Expect Move("1Gv1[e]\<Esc>") ==# [1, 8]
        Expect Move("1Gv2[e]\<Esc>") ==# [1, 22]
        Expect Move("1Gv3[e]\<Esc>") ==# [2, 6]
        Expect Move("1Gv4[e]\<Esc>") ==# [2, 13]
        Expect Move("1Gv5[e]\<Esc>") ==# [3, 11]
      end
    end

    context 'in Operator-pending mode'
      it 'supports count'
        Expect Do('1Gy[e]') ==# 'function'
        Expect Do('1Gy1[e]') ==# 'function'
        Expect Do('1Gy2[e]') ==# 'function! TestFunction'
        Expect Do('1Gy3[e]') ==# "function! TestFunction\n  echo"
        Expect Do('1Gy4[e]') ==# "function! TestFunction\n  echo 123456"
        Expect Do('1Gy5[e]') ==# "function! TestFunction\n  echo 123456\nendfunction"
      end
    end
  end

  describe '<Plug>(smartwod-ge)'
    context 'in Normal mode'
      it 'supports count'
        Expect Move('G$[ge]') ==# [2, 13]
        Expect Move('G$1[ge]') ==# [2, 13]
        Expect Move('G$2[ge]') ==# [2, 6]
        Expect Move('G$3[ge]') ==# [1, 22]
        Expect Move('G$4[ge]') ==# [1, 8]
        Expect Move('G$5[ge]') ==# [1, 1]
      end
    end

    context 'in Visual mode'
      it 'supports count'
        Expect Move("G$v[ge]\<Esc>") ==# [2, 13]
        Expect Move("G$v1[ge]\<Esc>") ==# [2, 13]
        Expect Move("G$v2[ge]\<Esc>") ==# [2, 6]
        Expect Move("G$v3[ge]\<Esc>") ==# [1, 22]
        Expect Move("G$v4[ge]\<Esc>") ==# [1, 8]
        Expect Move("G$v5[ge]\<Esc>") ==# [1, 1]
      end
    end

    context 'in Operator-pending mode'
      it 'supports count'
        Expect Do('G$y[ge]') ==# "6\nendfunction"
        Expect Do('G$y1[ge]') ==# "6\nendfunction"
        Expect Do('G$y2[ge]') ==# "o 123456\nendfunction"
        Expect Do('G$y3[ge]') ==# "n\n  echo 123456\nendfunction"
        Expect Do('G$y4[ge]') ==# "n! TestFunction\n  echo 123456\nendfunction"
        Expect Do('G$y5[ge]') ==# "function! TestFunction\n  echo 123456\nendfunction"
      end
    end
  end
end
