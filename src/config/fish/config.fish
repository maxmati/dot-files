<?php if (gethostname() === "leopardus"): ?>
mkdir -m 700 -p /tmp/maxmati
mkdir -m 700 -p /tmp/maxmati/downloads
<?php endif; ?>

if status --is-interactive
	keychain --eval --quiet -Q id_ed25519 | source
else
	keychain --eval --quiet --noask -Q id_ed25519  | source
end

set PATH ~/.cargo/bin ~/.gem/ruby/2.4.0/bin/ ~/.local/bin $PATH
alias grep="grep --color=auto"
set GREP_OPTIONS

set NPM_PACKAGES "$HOME/.npm-packages"
set PATH $PATH $NPM_PACKAGES/bin "/usr/local/bin" "$HOME/go/bin"
#set MANPATH "$NPM_PACKAGES/share/man:$(manpath)"
set NODE_PATH "$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate ''
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'


function fish_prompt
  set last_status $status

  printf '%s@%s ' (whoami) (hostname)

  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)
  set_color normal

  printf '%s ' (__fish_git_prompt)

  set_color normal
end

