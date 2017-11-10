# Fish config

alias c clear
alias g git
alias l 'less --tabs=4 -FRSX'
alias dj django-admin
alias bc 'bc -l'
alias gcm 'git checkout master'
complete --command g --wraps git
complete --command dj --wraps django-admin
complete --command trizen --wraps pacman

function fish_greeting
  date
end

set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_untrackedfiles 'untracked'
set __fish_git_prompt_char_cleanstate 'ok'
set __fish_git_prompt_char_invalidstate '¤'
set __fish_git_prompt_char_stateseparator '|'

set -x PIP_USE_WHEEL 'true'
set -x PIP_WHEEL_DIR '/home/jwa/.config/pip/wheels'
set -x PIP_FIND_LINKS '/home/jwa/.config/pip/wheels'
set -x PIP_DOWNLOAD_CACHE '/home/jwa/.config/pip/cache'

set -gx VIRTUALFISH_HOME $HOME/.venvs
eval (python -m virtualfish auto_activation)
eval (direnv hook fish)

set -x GPGKEY 29D2D3731CC0A5F2
set -x GPG_TTY (tty)
set -x EDITOR nvim
set -gx PATH $PATH ~/Scripts ~/.local/bin
set -x SHELL /usr/bin/fish

# curl -sfL https://git.io/fundle-install | fish
fundle plugin 'tuvistavie/fish-ssh-agent'
#fundle plugin 'fisherman/pipenv'
fundle init

