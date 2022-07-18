# vim-smartword

**Smartword** is a Vim plugin to provide `{motion}`s on words which are smarter
than the built-in ones in some sense.  For example, `w` moves the cursor to
the next word as follows (here "#" means a position to which `w` moves the
cursor for each time):

	<a href="http://www.vim.org/">www.vim.org</a>
	 ^ ^   ^ ^   ^  ^  ^^  ^^  ^  ^  ^^  ^^  ^ ^

Because there are two types of words and `w` moves to the next word which can
be the both types.  Let's call "L" for a type of words and "P" for another
type of words, where "L" means a word which consists of a sequence of letters
(which are defined by 'iskeyword' option) and "P" means a word which consists
of a sequence of other non-blank characters.

In many cases, you might want to move to the next "L", not "P".  This plugin
provides `{motion}`s to behave so.  For example, `<Plug>(smartword-w)` which is
corresponding to `w` moves the cursor as follows:

	<a href="http://www.vim.org/">www.vim.org</a>
	 ^ ^     ^      ^   ^   ^     ^   ^   ^    ^
