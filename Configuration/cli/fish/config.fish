
### VARIABLES ###
set -U fish_user_paths $HOME/.local/bin $HOME/Applications '/bin' '/usr/local/bin' '/usr/bin' '/usr/sbin' '/sbin' '/home/craole/.local/bin' '/usr/bin/core_perl' '/home/craole/code/go/bin' '/home/craole/.cargo/bin/' '/home/craole/.local/npm/node_modules/.bin' '/home/craole/.deno/bin' '~/.emacs.d/bin' $fish_user_paths 

### Wayland ###
set -x MOZ_ENABLE_WAYLAND 1
set -x SDL_VIDEODRIVER 'wayland'