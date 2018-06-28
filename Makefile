default: dist/imageutils-1.1.0.tar.gz

dist/imageutils-1.1.0.tar.gz: imageutils
	docker cp $<:/tmp/imageutils.tar.gz .
	mkdir -p $$(dirname $@)
	mv imageutils.tar.gz $@

clean:
	rm -rf src/ dist/
	-docker rm imageutils

test:
	docker run -it -v `pwd`:/app/buildpack:ro heroku/buildpack-testrunner

src/mozjpeg-3.2-release-source.tar.gz:
	mkdir -p $$(dirname $@)
	curl -sL https://github.com/mozilla/mozjpeg/releases/download/v3.2/mozjpeg-3.2-release-source.tar.gz -o $@

src/libpng-1.6.34.tar.gz:
	mkdir -p $$(dirname $@)
	curl -sL ftp://ftp-osl.osuosl.org/pub/libpng/src/libpng16/libpng-1.6.34.tar.gz -o $@

src/pngquant-2.12.1: src/libpng-1.6.34.tar.gz
	mkdir -p $$(dirname $@)
	rm -rf $@
	git clone -b 2.12.1 --recursive https://github.com/pornel/pngquant.git $@

src/gifsicle-v1.91:
	mkdir -p $$(dirname $@)
	rm -rf $@
	git clone -b v1.91 https://github.com/kohler/gifsicle.git $@

.PHONY: imageutils test clean

imageutils: src/mozjpeg-3.2-release-source.tar.gz src/pngquant-2.12.1 src/gifsicle-v1.91
	docker build --rm -t jonathantron/$@ .
	-docker rm $@
	docker run --name $@ jonathantron/$@ /bin/echo $@
