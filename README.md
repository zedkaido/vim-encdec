# encdec.vim

Encode with `[` decode with `]`. 

	(Visual){mapping}(motion)
	-------------------------
	[u    URI Encode
	]u    URI Decode 
	[C    C String Encode
	]C    C String Decode
	[x    XML/HTML Encode 
	]x    XML/HTML Decode
	[h    txt/bin -> Hex
	]h    Hex -> txt/bin
	[H    Hexdump file (%) (bin -> hexdump)
	]H    Hexdump back to raw data
	[64   Base64 Encode txt/bin
	]64   Base64 Decode to txt/bin
	[32   Base32 Encode txt/bin
	]32   Base32 Decode to txt/bin

Refer to [doc/encdec.txt](./doc/encdec.txt) for all keymaps (`:h vim-encdec` in vim).

## Installation

Install using your favourite package manager, or use Vim's built-in way:

	mkdir -p ~/.vim/pack/plugins/start/
	cd ~/.vim/pack/plugins/start/
	git clone https://git.zedkaido.com/vim-encdec.git
	vim -u NONE -c "helptags vim-encdec/doc" -c q 

## FAQ

> `[` and `]` are hard to type in my non-US keyboard layout.

	nmap < [
	nmap > ]
	omap < [
	omap > ]
	xmap < [
	xmap > ]
