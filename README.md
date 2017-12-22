# heroku-buildpack-imageutils

This heroku builpack provides the following tools to work with images:

- [mozjpeg v3.2](https://github.com/mozilla/mozjpeg)
- [pngquant v2.11.4](https://pngquant.org/) compiled with a static [libpng v1.6.34](http://www.libpng.org/pub/png/libpng.html)

## Using

All binaries are installed in `/app/vendor/imageutils/bin`, and this directory 
is automatically added to your `$PATH`.

### Composed

[Heroku now supports using multiple buildpacks for an app](https://devcenter.heroku.com/articles/using-multiple-buildpacks-for-an-app).

```bash
heroku buildpacks:add --index 1 https://github.com/jonathantron/heroku-buildpack-imageutils.git
git push heroku master
```

You can also lock the buildpack to a specific version:

```bash
heroku buildpacks:add --index 1 https://github.com/jonathantron/heroku-buildpack-imageutils.git#1.0.0
git push heroku master
```

## Building

This uses Docker to build against Heroku
[stack-image](https://github.com/heroku/stack-images)-like images.

```bash
make
```

Artifacts will be dropped in `dist/`.  See `Dockerfile`s for build options.
