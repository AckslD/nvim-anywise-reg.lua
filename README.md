# nvim-anywise-reg.lua

## Short intro
Did you ever felt like doing `daf` and then `p` to paste a function somewhere else without having to care if the cursor is in the middle of a function or not, in the same way as doing `dd` followed by `p` to move a line somewhere? Then `anywise-reg` is for you.

![](anywise.gif)

## Longer intro
One of the most satisfying things in my opinion when using vim is the easy of doing `xp` of `ddp` to move a character to the right or a line down.
The reason this works (using a single key `p` for pasting) is that vim keeps track of what was yanked.
In particular vim keeps track if the yank was charwise, linewise or blockwise in order to determine how the content of the register should be pasted.

Now wouldn't it be amazing if this notion could be generalised to more complex patterns, such as words (`daw`), paragraphs (`dap`) or functions and classes (`daf`, `dac` from e.g. [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)).
This is exactly what `anywise-reg` does, namely extending the registers to not only have a notion of `charwise`, `linewise` and `blockwise` but any pattern.

`anywise-reg` keeps track of what text-object was used for yanking the text (and into what register) in order to determine how to paste it.
Before pasting the cursor is simply moved to the end of the same text-object currently under the cursor.
In this way there is no hard-coded behaviour, rather the text-objects behaviour is reused and therefore any text-object could be used.

# Installation

Use your favourite plugin manager, for example using [`packer.nvim`](https://github.com/wbthomason/packer.nvim)
```lua
use {
    'AckslD/nvim-anywise-reg.lua',
}
```
or [`vim-plug`](https://github.com/junegunn/vim-plug):
```vim
Plug 'AckslD/nvim-anywise-reg.lua'
```

# Usage
The plugin needs to be enabled by calling it's setup function.
```lua
require("anywise_reg").setup()
```
By default no keybindings are enabled, see below for configuration.

# Configuration
To use `anywise-reg` you need to specify which operators and textobjects you want keep track of and what key to paste with.
The default config is:
```lua
require("anywise_reg").setup({
    operators = {},
    textobjects = {},
    paste_key = nil,
    register_print_cmd = false,
})
```
For example to be able to only delete (`d`) "outer words" (`aw`), call the setup as follows:
```lua
require("anywise_reg").setup({
    paste_key = 'p',
    operators = {'d'},
    textobjects = {'aw'},
})
```
This will setup keybindings for `daw`, `p` `""p` and `"[0-9a-z]p` in normal mode.

`textobjects` can either be a table of strings or a table of table of strings.
In the latter case the cartesian product will be taken between all tables to avoid repetition.
For example a standard config might look like:
```lua
require("anywise_reg").setup({
    paste_key = 'p',
    operators = {'y', 'd', 'c'},
    textobjects = {
        {'i', 'a'},
        {'w', 'W', 'f', 'c'},
    },
})
```

# TODOs and questions
* When to prune the information stored in the registers?
* Currently the numbered registers are not updated as they should, the data should be shifted any time something is deleted.
* How can registers when pasting be handled better? Currently we add a keybind for each register but maybe there is some smarter way.
* Add a command similar to `:reg` to easily see the generalised content of the registers.
