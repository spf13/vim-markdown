" Vim filetype plugin
" Language:		Markdown
" Maintainer:		Tim Pope <vimNOSPAM@tpope.org>

if exists("b:did_ftplugin")
  finish
endif

runtime! ftplugin/html.vim ftplugin/html_*.vim ftplugin/html/*.vim
unlet! b:did_ftplugin

setlocal comments=fb:*,fb:-,fb:+,n:> commentstring=>\ %s
setlocal formatoptions+=tcqln
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^[-*+]\\s\\+
setlocal expandtab

let b:undo_ftplugin .= "|setl cms< com< fo<"

let s:jumpList = []

function MarkdownJumpRef()
	let line = getline('.')
	let curcol = virtcol('.')
	let start = curcol - 1
	let end = curcol - 1

	while start >= 0
		if line[start] == '['
			break
		endif
		let start = start - 1
	endwhile

	while end < strlen(line)
		if line[end] == ']'
			break
		endif
		let end = end + 1
	endwhile

	if line[start] != '[' || line[end] != ']'
		return -1
	endif

	let ref = strpart(line, start + 1, end - start - 1)
	let ref = "^\\[" . ref . "\\]:"
	let pos = getpos('.')
	let linenon = search(ref)
	let npos = getpos('.')

	if pos != npos
		let s:jumpList = add(s:jumpList, pos)
	endif

	let line = getline('.')

	let c = 0
	while c < strlen(line)
		if line[c] == ':'
			break
		endif
		let c = c + 1
	endwhile

	let npos[2] = c + 2
	call setpos('.', npos)
	return 0
endfunction

function MarkdownJumpBack()
	let l = len(s:jumpList)
	if l <= 0
		return
	endif
	let pos = s:jumpList[l - 1]
	let s:jumpList = s:jumpList[:l - 2]

	call setpos('.', pos)
endfunction

map <C-]> :call MarkdownJumpRef()<CR>
map <C-T> :call MarkdownJumpBack()<CR>

" vim:set sw=2:
