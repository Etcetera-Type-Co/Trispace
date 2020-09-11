#!/bin/sh
set -e
source ../env/bin/activate

OTF_DIR=../fonts/static/otf
TTF_DIR=../fonts/static/ttf
WEB_DIR=../fonts/web

#requires https://github.com/bramstein/homebrew-webfonttools

echo ".
MAKE WEBFONTS
."
rm -rf $WEB_DIR
mkdir -p $WEB_DIR $WEB_DIR/woff $WEB_DIR/woff2

vf=$(ls ../fonts/variable/*.ttf)
for fonts in $vf
do
  woff2_compress $fonts
done

ttfs=$(ls $TTF_DIR/*.ttf)
for fonts in $ttfs
do
  woff2_compress $fonts
  sfnt2woff-zopfli $fonts
done

woffs=$(ls $TTF_DIR/*.woff*)
for fonts in $woffs
do
	mv $fonts $WEB_DIR
done

woff=$(ls $WEB_DIR/*.woff)
for fonts in $woff
do
	mv $fonts $WEB_DIR/woff/
done

woff2=$(ls $WEB_DIR/*.woff2)
for fonts in $woff2
do
	mv $fonts $WEB_DIR/woff2/
done



echo ".
COMPLETE!
."
