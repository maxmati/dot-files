set PATH $PATH ~/bin ~/.gem/ruby/2.0.0/bin/
alias grep="grep --color=auto"
set GREP_OPTIONS

set NPM_PACKAGES "$HOME/.npm-packages"
set PATH $PATH $NPM_PACKAGES/bin
#set MANPATH "$NPM_PACKAGES/share/man:$(manpath)"
set NODE_PATH "$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

