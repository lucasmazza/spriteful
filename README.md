# Spriteful

Spriteful is a sprite generator tool.

## Usage

Lets say that you have your images in `images/icons/` and you want to generate a sprite for them.

```bash
spriteful images/icons
```

Boom! Spriteful will generate a `icons.png` in your working directory and copy the respective CSS
for your sprite to your clipboard.

```bash
# TODO:
spriteful images/icons -s stylesheets -d images
```

### TODO: Multiple sprites

```bash
spriteful images/icons -s stylesheets -d images
```

### TODO: Spriteful and Rails

```bash
spriteful --rails
```

## Available options

* `--stylesheets` (`-s`) - Directory to save the generated stylesheet(s), instead of copying them to the clipboard.
* `--destination` (`-d`) - Directory to save the generated image(s).
* `--rails` (`-r`) - Forces rails specific settings, see [Spriteful and Rails](#spriteful-and-rails) for more info.
* `--format` (`-f`) - Format to generate the sprite(s) stylesheet(s). Either "css" or "scss".
