if !has('vim9script')
	echoe "encdec requires vim9++"
endif
if exists("loaded_encdec")
	finish
endif

vim9script
g:loaded_encdec = true

def Mutate(Fn: func(string): string, type: string)
	var sel_save = &selection
	var cb_save = &clipboard
	set selection=inclusive clipboard-=unnamed clipboard-=unnamedplus
	var reg_save = getreginfo('@')

	if type == 'line'
		exe "normal! '[V']y"
		setreg('"', substitute(getreg('"'), "\n$", '', ''))
	elseif type == 'block'
		exe "normal! `[\<C-V>`]y"
	elseif type == 'char'
		exe "normal! `[v`]y"
	else	
		return
	endif

	var s = getreg('"')
	setreg('"', Fn(s))

	normal! gvp
	setreg('@', reg_save)
	&selection = sel_save
	&clipboard = cb_save
enddef

# ------------------------------------------------------------------------------

def URIEncode(s: string): string
	return uri_encode(s)
enddef

def URIDecode(s: string): string
	return uri_decode(s)
enddef

def MapURIEncode(type: string = '')
	Mutate(URIEncode, type)
enddef

def MapURIDecode(type: string = '')
	Mutate(URIDecode, type)
enddef

nnoremap [u <ScriptCmd>set opfunc=MapURIEncode<CR>g@
nnoremap ]u <ScriptCmd>set opfunc=MapURIDecode<CR>g@
nnoremap [uu <ScriptCmd>set opfunc=MapURIEncode<CR>g@_
nnoremap ]uu <ScriptCmd>set opfunc=MapURIDecode<CR>g@_
xnoremap [u <ScriptCmd>set opfunc=MapURIEncode<CR>g@
xnoremap ]u <ScriptCmd>set opfunc=MapURIDecode<CR>g@

# ------------------------------------------------------------------------------

def CStringEncode(s: string): string
	const escapes = {"\n": 'n', "\r": 'r', "\t": 't', "\b": 'b', "\f": 'f', '"': '"', "\\": "\\"}
	return substitute(s, "[\n\r\t\b\f\\\\\"]", (m) =>
		'\' .. escapes[m[0]], 'g')
enddef

def CStringDecode(s: string): string
	var str = s->trim()
	if str[0] == '"'
		return eval(str)
	endif
	return eval($'"{str}"')
enddef

def MapCStringEncode(type: string = '')
	Mutate(CStringEncode, type)
enddef

def MapCStringDecode(type: string = '')
	Mutate(CStringDecode, type)
enddef

nnoremap [s <ScriptCmd>set opfunc=MapCStringEncode<CR>g@
nnoremap ]s <ScriptCmd>set opfunc=MapCStringDecode<CR>g@
nnoremap [ss <ScriptCmd>set opfunc=MapCStringEncode<CR>g@_
nnoremap ]ss <ScriptCmd>set opfunc=MapCStringDecode<CR>g@_
xnoremap [s <ScriptCmd>set opfunc=MapCStringEncode<CR>g@
xnoremap ]s <ScriptCmd>set opfunc=MapCStringDecode<CR>g@

# ------------------------------------------------------------------------------

def XMLEncode(s: string): string
	var str = s
	str = substitute(str, '&', '\&amp;', 'g')
	str = substitute(str, '<', '\&lt;', 'g')
	str = substitute(str, '>', '\&gt;', 'g')
	str = substitute(str, '"', '\&quot;', 'g')
	str = substitute(str, "'", '\&apos;', 'g')
	str = substitute(str, '[^\x00-\x7F]', (m) => '&#' .. char2nr(m[0]) .. ';', 'g')
	return str
enddef

def XMLDecode(s: string): string
	var str = s
	str = substitute(str, '<\%([[:alnum:]-]\+=\%("[^"]*"\|''[^'']*''\)\|.\)\{-\}>', '', 'g')
	str = substitute(str, '&lt;', '<', 'g')
	str = substitute(str, '&gt;', '>', 'g')
	str = substitute(str, '&quot;', '"', 'g')
	str = substitute(str, '&apos;', "'", 'g')
	str = substitute(str, '&amp;', '\&', 'g')
	str = substitute(str, '&#\d\+;', (m) => nr2char(str2nr(matchstr(m[0], '\d\+'))), 'g')
	return str
enddef

def MapXMLEncode(type: string = '')
	Mutate(XMLEncode, type)
enddef

def MapXMLDecode(type: string = '')
	Mutate(XMLDecode, type)
enddef

nnoremap [x <ScriptCmd>set opfunc=MapXMLEncode<CR>g@
nnoremap ]x <ScriptCmd>set opfunc=MapXMLDecode<CR>g@
nnoremap [xx <ScriptCmd>set opfunc=MapXMLEncode<CR>g@_
nnoremap ]xx <ScriptCmd>set opfunc=MapXMLDecode<CR>g@_
xnoremap [x <ScriptCmd>set opfunc=MapXMLEncode<CR>g@
xnoremap ]x <ScriptCmd>set opfunc=MapXMLDecode<CR>g@

# ------------------------------------------------------------------------------

def HexEncode(s: string): string
	var hexstr = system("xxd -p | tr -d '\n'", s)
	hexstr = substitute(hexstr, '0a', "0a\n", 'g')
	return hexstr
enddef

def HexDecode(s: string): string
	return system("xxd -r -p", s)
enddef

def MapHexEncode(type: string = '')
	Mutate(HexEncode, type)
enddef

def MapHexDecode(type: string = '')
	Mutate(HexDecode, type)
enddef

nnoremap [h <ScriptCmd>set opfunc=MapHexEncode<CR>g@
nnoremap ]h <ScriptCmd>set opfunc=MapHexDecode<CR>g@
nnoremap [hh <ScriptCmd>set opfunc=MapHexEncode<CR>g@_
nnoremap ]hh <ScriptCmd>set opfunc=MapHexDecode<CR>g@_
xnoremap [h <ScriptCmd>set opfunc=MapHexEncode<CR>g@
xnoremap ]h <ScriptCmd>set opfunc=MapHexDecode<CR>g@
nnoremap [H :%!xxd<CR>
nnoremap ]H :%!xxd -r<CR>

# ------------------------------------------------------------------------------

def Base64Encode(s: string): string
	return system("base64 | tr -d '\n'", s)
enddef

def Base64Decode(s: string): string
	return system("base64 -d", s)
enddef

def MapBase64Encode(type: string = '')
	Mutate(Base64Encode, type)
enddef

def MapBase64Decode(type: string = '')
	Mutate(Base64Decode, type)
enddef

nnoremap [64 <ScriptCmd>set opfunc=MapBase64Encode<CR>g@
nnoremap ]64 <ScriptCmd>set opfunc=MapBase64Decode<CR>g@
xnoremap [64 <ScriptCmd> set opfunc=MapBase64Encode<CR>g@
xnoremap ]64 <ScriptCmd> set opfunc=MapBase64Decode<CR>g@

# ------------------------------------------------------------------------------

def Base32Encode(s: string): string
	return system("base32 | tr -d '\n'", s)
enddef

def Base32Decode(s: string): string
	return system("base32 -d", s)
enddef

def MapBase32Encode(type: string = '')
	Mutate(Base32Encode, type)
enddef

def MapBase32Decode(type: string = '')
	Mutate(Base32Decode, type)
enddef

nnoremap [32 <ScriptCmd>set opfunc=MapBase32Encode<CR>g@
nnoremap ]32 <ScriptCmd>set opfunc=MapBase32Decode<CR>g@
xnoremap [32 <ScriptCmd> set opfunc=MapBase32Encode<CR>g@
xnoremap ]32 <ScriptCmd> set opfunc=MapBase32Decode<CR>g@
