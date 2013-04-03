zmodload zsh/parameter
autoload -U is-at-least

local this_file="${funcsourcetrace[1]%:*}"
if is-at-least 4.3.10; then
  # "A" flag (turn a file name into an absolute path with symlink
  # resolution) is only available on 4.3.10 and latter
  local cur_dir="${this_file:A:h}"
else
  local cur_dir="${this_file:h}"
fi
mkdir -p ~/.fonts
cd ~/.fonts
cp -a ${cur_dir:h}/fonts/**/* ~/.fonts
mkfontscale
mkfontdir
fc-cache -fv ~/.fonts
