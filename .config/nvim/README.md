

## Introduction

---

Most of the configurations for neovim found in this repository come from this video:

https://www.youtube.com/watch?v=6pAG3BHurdM

As well as from this blog from the same creator:

https://www.josean.com/posts/how-to-setup-neovim-2024

## Surrounding Characters/Tags

Some notes on creating surrounding characters for things like html tags, double quotes,
brackets, etc.

|Old text                 |Command     |New text              |
|-------------------------|------------|----------------------|
|surr*ound_words          |ysiw)       |(surround_words)      |
|*make strings            |ys$"        |"make strings"        |
|[delete ar*ound me!]     |ds]         |delete around me!     |
|remove \<b>HTML t*ags\</b> |dst         |remove HTML tags      |
|'change quot*es'         |cs'"        |"change quotes"       |
|\<b>or tag* types\</b>     |csth1<CR> |\<h1>or tag types\</h1> |
|delete(functi*on calls)  |dsf         |function calls        |


> Thanks to - https://github.com/kylechui/nvim-surround
