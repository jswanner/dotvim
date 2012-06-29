### Installing and Using

1. Install [tpope's][tpope] [pathogen] into `~/.vim/autoload/` and add the
   following line to your `~/.vimrc`:

        call pathogen#runtime_append_all_bundles()

     Be aware that it must be added before any `filetype plugin indent on`
     lines according to the install page:

     > Note that you need to invoke the pathogen functions before invoking
     > "filetype plugin indent on" if you want it to load ftdetect files. On
     > Debian (and probably other distros), the system vimrc does this early on,
     > so you actually need to "filetype off" before "filetype plugin indent on"
     > to force reloading.

[pathogen]: http://www.vim.org/scripts/script.php?script_id=2332
[tpope]: http://github.com/tpope/vim-pathogen

2. Create, and change into, the `~/.vim/bundle/` directory:

        $ mkdir -p ~/.vim/bundle
        $ cd ~/.vim/bundle

3. Make a clone of the `vim-coco` repository:

        $ git clone git://github.com/satyr/vim-coco.git
        [...]
        $ ls
        vim-coco/

That's it. Pathogen should handle the rest. Opening a file with a `.co`
extension or a `Cokefile` will load everything.

### Updating

1. Change into the `~/.vim/bundle/vim-coco/` directory:

        $ cd ~/.vim/bundle/vim-coco

2. Pull in the latest changes:

        $ git pull

Everything will then be brought up to date.

### CocoMake: Compile the Current File

The `CocoMake` command compiles the current file and parses any errors.

The full signature of the command is:

    :[silent] CocoMake[!] [co-OPTIONS]...

By default, `CocoMake` shows all compiler output and jumps to the first line
reported as an error by `coco`:

    :CocoMake

Compiler output can be hidden with `silent`:

    :silent CocoMake

Line-jumping can be turned off by adding a bang:

    :CocoMake!

Options given to `CocoMake` are passed along to `coco`:

    :CocoMake --bare

`CocoMake` can be manually loaded for a file with:

    :compiler co

#### Recompile on write

To recompile a file when it's written, add an `autocmd` like this to your
`vimrc`:

    au BufWritePost *.co silent CocoMake!

All of the customizations above can be used, too. This one compiles silently
and with the `-b` option, but shows any errors:

    au BufWritePost *.co silent CocoMake! -b | cwindow | redraw!

The `redraw!` command is needed to fix a redrawing quirk in terminal vim, but
can removed for gVim.

#### Default compiler options

The `CocoMake` command passes any options in the `co_make_options`
variable along to the compiler. You can use this to set default options:

    let co_make_options = '--bare'

#### Path to compiler

To change the compiler used by `CocoMake` and `CocoCompile`, set
`co_compiler` to the full path of an executable or the filename of one
in your `$PATH`:

    let co_compiler = '/usr/bin/coco'

This option is set to `coco` by default.

### CocoCompile: Compile Snippets of Coco

The `CocoCompile` command shows how the current file or a snippet of
Coco is compiled to JavaScript. The full signature of the command is:

    :[RANGE] CocoCompile [watch|unwatch] [vert[ical]] [WINDOW-SIZE]

Calling `CocoCompile` without a range compiles the whole file.

Calling `CocoCompile` with a range, like in visual mode, compiles the selected
snippet of Coco.

The scratch buffer can be quickly closed by hitting the `q` key.

Using `vert` splits the CocoCompile buffer vertically instead of horizontally:

    :CocoCompile vert

Set the `co_compile_vert` variable to split the buffer vertically by
default:

    let co_compile_vert = 1

The initial size of the CocoCompile buffer can be given as a number:

    :CocoCompile 4

#### Watch (live preview) mode

Writing some code and then exiting insert mode automatically updates the
compiled JavaScript buffer.

Use `watch` to start watching a buffer (`vert` is also recommended):

    :CocoCompile watch vert

After making some changes in insert mode, hit escape and your code will
be recompiled. Changes made outside of insert mode don't trigger this recompile,
but calling `CocoCompile` will compile these changes without any bad effects.

To get synchronized scrolling of a Coco and CocoCompile buffer, set
`scrollbind` on each:

    :setl scrollbind

Use `unwatch` to stop watching a buffer:

    :CocoCompile unwatch

### Configure Syntax Highlighting

Add these lines to your `vimrc` to disable the relevant syntax group.

#### Disable trailing whitespace error

Trailing whitespace is highlighted as an error by default. This can be disabled
with:

    hi link coSpaceError NONE

#### Disable reserved words error

Reserved words like `function` and `var` are highlighted as an error where
they're not allowed in Coco. This can be disabled with:

    hi link coReservedError NONE

### Tune Vim for Coco

Changing these core settings can make vim more Coco friendly.

#### Fold by indentation

Folding by indentation works well for Coco functions and classes.
To fold by indentation in Coco files, add this line to your `vimrc`:

    au BufNewFile,BufReadPost *.co setl foldmethod=indent nofoldenable

With this, folding is disabled by default but can be quickly toggled per-file
by hitting `zi`. To enable folding by default, remove `nofoldenable`:

    au BufNewFile,BufReadPost *.co setl foldmethod=indent

#### Two-space indentation

To get standard two-space indentation in Coco files, add this line to
your `vimrc`:

    au BufNewFile,BufReadPost *.co setl shiftwidth=2 expandtab
