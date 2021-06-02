# Dotfiles

## Installing

```console
$ sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply conradoqg
```

## Testing

```console
$ docker run -it --rm -v $PWD:/root/.local/share/chezmoi ubuntu-chezmoi bash
$ sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply
```
