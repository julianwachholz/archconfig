function fish_prompt --description 'Write out the prompt'

  if not set -q __fish_prompt_wide
    set -g __fish_prompt_wide " "
  end

  if not set -q __fish_prompt_host
    set -g __fish_prompt_host (string sub --length 5 (hostname))
  end

  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end

  #set USER root

  switch $USER

  case root

    if not set -q __fish_prompt_cwd
      if set -q fish_color_cwd_root
        set -g __fish_prompt_cwd (set_color red)
      else
        set -g __fish_prompt_cwd (set_color white)
      end
    end

    echo -n -s "$USER" ' ' "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" '# '

  case '*'
    echo -n -s (set_color -b blue black) "$__fish_prompt_wide$USER@$__fish_prompt_host$__fish_prompt_wide"
    echo -n -s (set_color -b brblack blue) ""
    echo -n -s (set_color -b brblack white) "$__fish_prompt_wide" (prompt_pwd) "$__fish_prompt_wide"
    echo -n -s (set_color brblack)

    if __fish_is_git_repository
      echo -n -s (set_color -b bryellow) ""
      echo -n -s (__fish_git_prompt "$__fish_prompt_wide%s") (set_color -b bryellow brblack) "$__fish_prompt_wide"
      echo -n -s (set_color bryellow)
    end

    if set -q VIRTUAL_ENV
      if __fish_is_git_repository
        echo -n -s (set_color -b green bryellow) ""
      else
        echo -n -s (set_color -b green brblack) ""
      end
      echo -n -s (set_color -b green black) "$__fish_prompt_wide" (basename $VIRTUAL_ENV) "$__fish_prompt_wide" (set_color normal)
      echo -n -s (set_color -b normal green) ""
    else
      echo -n -s (set_color -b black) ""
    end

    echo -n -s " $__fish_prompt_normal"

  end
end
