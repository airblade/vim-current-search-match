# current_search_match.vim

Highlights the current search match.

Uses the `PmenuSel` highlight group by default.  To use a different highlight:

1. Type `:hi` and find one you like, e.g. `Visual`.
2. Put `let g:current_search_match = 'Visual'` in your vimrc/init.vim.


## Installation

Install using your favourite package manager, or use Vim's built-in package
support:

    mkdir -p ~/.vim/pack/airblade/start
    cd ~/.vim/pack/airblade/start
    git clone https://github.com/airblade/vim-current-search-match.git
    vim -u NONE -c "helptags vim-current-search-match/doc" -c q


## Intellectual Property

Copyright 2021 Andrew Stewart.  Released under the MIT licence.

