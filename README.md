# Spriteful

Spriteful is a command line sprite generator tool, meant to be used regardless of your programming language,
application stack or Web framework.

## Usage

Lets say that you have your images in `images/icons/` and you want to generate a sprite for them.

```bash
spriteful images/icons
# create  icons.png
# create  icons.css
```

Boom! Spriteful will generate a `icons.png` in your working directory and the respective CSS
for your sprite in the `icons.css` file.

If you want a bit more of control on where we should place the combined image and the CSS, you
can use the `s` (for `stylesheets`) and `d` ( for `destination`) flags and Spriteful will place
your `icons.png` and `icons.css` in the desired directories.

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

Spriteful can generate SCSS code with the `-f` flag. This way the generated code will use
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

You can also choose to generate the code using
[Mixin Directives](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#mixins).

```bash
spriteful images/icons -f scss --mixin
# create  icons.png
# copy    icons.scss
```

```scss
// in your SCSS code...
.button {
  @include icons-sprite-new;
}
```

When using SCSS, the generated stylesheet will have a variable with a list of all images
inside the generated sprite, so you can hack own your own on top of that.

```scss
@each $image in $icons-sprite-names {
  .my-class-for-#{$image} {
    @extend %icons-sprite-#{$image};
  }
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
you. If run you the `spriteful` command with the `--rails` flag, all sprites under `app/assets/images/sprites`
will be generated with respective stylesheets at `app/assets/stylesheets/sprites`, using the proper `image_url`
helper for the format of your choice.

So, given that you have the `icons` and `flags` directories with your images under `app/assets/images/sprites`,
you might get a similar output when generating these two sprites.

```bash
spriteful --rails
# create  app/assets/images/sprites/flags.png
# create  app/assets/stylesheets/sprites/flags.css.erb
# create  app/assets/images/sprites/icons.png
# create  app/assets/stylesheets/sprites/icons.css.erb
```

## Naming conventions

Stylesheets and combined images will **always** follow the name of their source directories -
images under `icons` will generate the `icons.png` and `icons.css` files. This convention
enforces previsibility over generated files and helps when regenating existing sprites whenever
you need to add a new source to an existing sprite.

## Custom templates

If you need further customization of the sprite CSS, you can use a custom ERB template
to be used instead of the builtin templates.

```bash
spriteful  image/icons --template custom_template.erb
```

In this case, the `custom_template.erb` file will be evaluated in the context of a
`Spriteful::Template` instance. Please check this class documentation and source
to see all the available attributes and helpers.

You can copy one of the builtin templates to your working directory with the `template`
subcommand.

```bash
spriteful template
# create  spriteful.css
```

## SVG Support

Spriteful has a basic support for dealing with SVG images (and not only PNGs). SVG images
will be combined along the rest of your images and will be embedded directly on the final
Stylesheet in the data URI format. Using the `svg` root class (based on Modernizr), the
data URI will be used for browsers that support SVG images and the composed PNG will work
as a fallback for legacy browsers.
We recommend that you install librsvg to improve ImageMagick support for SVG images.

```css
.images.update-icon {
  background-position: 0px -10px;
}

.svg .images.update-icon {
  background-image: url('data:image/svg+xml;utf8, SVG XML goes here :)');
  background-position: 0 0;
}

```

Future versions of Spriteful could have support for generating composed images as SVG files
(and not only PNG), so feel free to send a contribution improving the feature.


## Image Optimization

Spriteful supports PNG optimization through the [image_optim](https://github.com/toy/image_optim)
gem. You should have one of the following utilities present on your system: `pngcrush`, `pngout`,
`optipng`, `advpng` or `pngquant`. If none can be found, the optimization will be skipped.

If you are using SVG images, the embedded SVG as data URI will be optimized with the
[svg_optimizer](https://github.com/fnando/svg_optimizer)  gem.

## Available options

* `--stylesheets` (`-s`) - Directory to save the generated stylesheet(s), instead of copying them to the clipboard.
* `--destination` (`-d`) - Directory to save the generated image(s).
* `--name` (`-n`) - Name of generated sprite.
* `--rails` (`-r`) - Forces rails specific settings, see [Spriteful and Rails](#spriteful-and-rails) for more info.
* `--format` (`-f`) - Format to generate the sprite(s) stylesheet(s). Either "css" or "scss".
* `--template` (`-t`) - The path for a custom Stylesheet template.
* `--mixin` - Choose to use the Mixin Directives instead of Placeholder Selector.
* `--horizontal` - Changes the sprite orientation to horizontal, since all sprites are combined vertically by default.
* `--save` - Saves the provided arguments for later use.
* `--spacing` - Add some spacing between the images in the sprite.
* `--no-optimize` - Skip optimizing SVG images.

You can add a `.spritefulrc` file with default options to your home directory or the current one that they will
be picked up whenever you run the `spriteful` command.

### Examples

This repository contains an `examples` folder with some very simple sprites and the output generated
by Spriteful. Feel free to take a look or try it on your own by cloning this repository and running
`spriteful` on it.
