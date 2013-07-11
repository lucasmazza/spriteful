# Spriteful

Spriteful is a command line sprite generator tool, meant to be used regardless of your programming language, application stack or Web framework.

## Usage

Lets say that you have your images in `images/icons/` and you want to generate a sprite for them.

```bash
spriteful images/icons
# create  icons.png
# copy    icons.css
```

Boom! Spriteful will generate a `icons.png` in your working directory and copy the respective CSS
for your sprite to your clipboard.

If you want a bit more of control on where we should place the combined image and the CSS, you
can use the `s` (for `stylesheets`) and `d` ( for `destination`) flags and Spriteful will place
your `icons.png` in a specific directory and will save the CSS in the `icons.css` file instead
of copying it to your clipboard.

```bash
spriteful images/icons -s stylesheets -d images
# create  images/icons.png
# create  stylesheets/icons.css
```

### The CSS

By default, Spriteful will generate a set of CSS classes based on the images of your sprite. In the
case of having a `new.png` image in our `icons` sprite, you can use it putting together the `icons`
and `new` class.

```html
<a href='/new' class='icons new'>New thing</a>
```

### SCSS support

Spriteful can generate SCSS-ish code with the `-f` flag. This way the generated code will use
[Placeholder Selectors](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#placeholder_selectors_)
instead of generating a class for each image in your sprite.

```bash
spriteful images/icons -f scss
# create  icons.png
# copy    icons.scss
```

```scss
// in your SCSS code...
.button {
  @extend %icons-sprite-new;
}
```

### Multiple sprites

You can deal with multiple sprites in a single run. If `images/icons` has a set of images for one
sprite and `images/flags` another set you can generate both `icons.png` and `flags.png` with a single
execution.

```bash
spriteful images/icons images/flags -s stylesheets -d images
# create  images/icons.png
# create  stylesheets/icons.css
# create  images/flags.png
# create  stylesheets/flags.css
```

### Spriteful and Rails

If you are working on a Ruby on Rails application Spriteful can provide some extra goodies for
you. If you the `spriteful` command with the `--rails` flag, all sprites under `app/assets/images/sprites` will be generated with respective stylesheets at `app/assets/stylesheets/sprites`, using the proper `image_url` helper for the format of your choice.

So, given that you have the `icons` and `flags` directories with your images under `app/assets/images`, you might get a similar output when generating these two sprites.

```bash
spriteful --rails
# create  app/assets/images/sprites/flags.png
# create  app/assets/stylesheets/sprites/flags.css.erb
# create  app/assets/images/sprites/icons.png
# create  app/assets/stylesheets/sprites/icons.css.erb
```

## Available options

* `--stylesheets` (`-s`) - Directory to save the generated stylesheet(s), instead of copying them to the clipboard.
* `--destination` (`-d`) - Directory to save the generated image(s).
* `--rails` (`-r`) - Forces rails specific settings, see [Spriteful and Rails](#spriteful-and-rails) for more info.
* `--format` (`-f`) - Format to generate the sprite(s) stylesheet(s). Either "css" or "scss".

You can add a `.spritefulrc` file with default options to your home directory or the current one that they will be picked up whenever you run the `spriteful` command.

### Examples

This repository contains an `examples` folder with some very simple sprites and the output generated
by Spriteful. Feel free to take a look or try it on your own by cloning this repository and running
`spriteful` on it.
