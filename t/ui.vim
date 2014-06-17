runtime! plugin/smartword.vim

function! ListAvailableModes(lhs)
  let modes = ['n', 'x', 's', 'o', 'i', 'c', 'l']
  call filter(modes, 'maparg(' . string(a:lhs) . ', v:val) != ""')
  return modes
endfunction

describe 'vim-smartinput'
  it 'provides UI key mappings'
    let movement_modes = ['n', 'x', 's', 'o']
    Expect ListAvailableModes('<Plug>(smartword-w)') ==# movement_modes
    Expect ListAvailableModes('<Plug>(smartword-b)') ==# movement_modes
    Expect ListAvailableModes('<Plug>(smartword-e)') ==# movement_modes
    Expect ListAvailableModes('<Plug>(smartword-ge)') ==# movement_modes
  end
end
