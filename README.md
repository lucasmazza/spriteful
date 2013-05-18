# Spriteful

Spriteful is a sprite generator tool built on top of [Compass](https://github.com/chriseppstein/compass).

## Why

Compass has great features for dealing with sprites, but is not my favorite tool for every kind
of project. So, I want to use Compass internals without having the whole Compass as a dependency.

## Usage

Lets say that you have your images in `images/icons/` and you want to generate a sprite for them.

```bash
spriteful images/icons
```

Boom! Spriteful will generate a `icons.png` in your working directory and copy the respective CSS
for your sprite to your clipboard.

```bash
spriteful images/icons --css stylesheets ---img images
```

### Multiple sprites

```bash
spriteful images/icons --css stylesheets ---img images
```

### Spriteful and Rails

```bash
spriteful --rails
```

## Available options

* `--css` - Directory to save the generated stylesheet(s), instead of copying them to the clipboard.
* `--img`. - Directory to save the generated image(s).
* `--rails`. - Forces rails specific settings, see [Spriteful and Rails](#spriteful-and-rails) for more info.
* `--template`. - Use a custom ERB/SCSS template file to use with Compass.
