# DOTS

_Portable_ tools and configuration variables.

## Installation

### Unix

- Set bash as default $SHELL and update the profile.
- Logout to initialize. Other shells can be loaded intractively via `init_shell [shell]`.

```sh $HOME/.profile
#| Enable global exports
set -o allexport

#| Declare DATA_STORE
if [ -d /store/DOTS ]; then
  DATA_STORE="/store"
elif [ -d /storage/DOTS ]; then
  DATA_STORE="/storage"
else
  DATA_STORE="$HOME"
fi

#| Declare DOTS
[ -d "$DATA_STORE/DOTS" ] &&
  DOTS="$DATA_STORE/DOTS"

#| Disable global exports
set +o allexport

#| Initialize DOTS
# shellcheck disable=SC1091
[ -f "$DOTS/.dotsrc" ] &&
  . "$DOTS/.dotsrc"
```

```sh $HOME/.bashrc
# shellcheck disable=SC1091
[ -f "$HOME/.profile" ] &&
  . "$HOME/.profile"
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](../LICENSE)
