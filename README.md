# ankifly.nvim

## Description

Create anki cards and decks on the fly. Should work with most card types/models but only tested with "Basic" and "Cloze" cards. It is also possible to add code blocks with the right anki plugin.
At the moment it only supports "Highlight Code" with the plugin number "112228974" simply because I'm using it.

## Requirements

### Neovim

- Neovim >= 0.8.0
- plenary.nvim

### Anki

- AnkiConnect

### OS

- curl

## Requirements Optional

### Neovim

- dressing.nvim -> nicer ui for vim.ui.select and vim.ui.input
  - telescope.nvim or fzf.vim -> use a telescope/fzf picker for vim.ui.select
- nvim-markdown or similar

### Anki

- Highlight Code(Plugin)

## Installation

I use packer but any plugin manager should work. Check the documentation of yours.

### Packer

#### The Plugin

```lua
use('rolfworld/ankifly.nvim')
```

#### If Not Already Installed

```lua
use("nvim-lua/plenary.nvim")
```

## Usage

Open Anki, Anki has to be running and AnkiConnect has to be installed for the plugin to work!
Open Neovim and use one of the commands below.

### Commands

Anki -> choose deck and card type/model
AnkiBasic -> choose deck and use "Basic" card
AnkiCloze -> choose deck and use "Cloze" card

You can add a new deck by choosing "Add Deck" in the deck select menu and a prompt for
a new name will appear.
If you used Anki command it will than prompt to choose a type/model.
Than a floating window will open with markdown set as filetype.
It will contain the card type/model appropriate fields.

### Adding Code Block

Same as in markdown.

````
```lua
local function foo()
  print("Schwarzwald")
end
```
````

### Keymaps

#### Menus

Quit <ESC>

#### Card Buffer

Quit q
Save <S-s>

Both in normal mode.
