#!/bin/sh
set -e
source ../env/bin/activate

OTF_DIR=../fonts/static/otf
TTF_DIR=../fonts/static/ttf
WEB_DIR=../fonts/web

echo ".
MAKE UFO
."
rm -rf *.ufo
glyphs2ufo Trispace.glyphs --generate-GDEF
rm Trispace.designspace
mv Trispace-CondensedThin.ufo TrispaceCondensed-Thin.ufo
mv Trispace-ExpandedThin.ufo TrispaceExpanded-Thin.ufo
mv Trispace-CondensedExtraBold.ufo TrispaceCondensed-ExtraBold.ufo
mv Trispace-ExpandedExtraBold.ufo TrispaceExpanded-ExtraBold.ufo

##########################################

echo ".
GENERATING STATICS
."
rm -rf $OTF_DIR $TTF_DIR
mkdir -p $OTF_DIR $TTF_DIR

fontmake -m Trispace-static.designspace -i -o ttf --output-dir $TTF_DIR
fontmake -m Trispace-static.designspace -i -o otf --output-dir $OTF_DIR

##########################################

echo ".
POST-PROCESSING TTF
."
ttfs=$(ls $TTF_DIR/*.ttf)
for fonts in $ttfs
do
	gftools fix-dsig -f $fonts
	ttfautohint $fonts $fonts.fix
	[ -f $fonts.fix ] && mv $fonts.fix $fonts
	gftools fix-hinting $fonts
	[ -f $fonts.fix ] && mv $fonts.fix $fonts
done

##########################################

echo ".
POST-PROCESSING 0TF
."
otfs=$(ls $OTF_DIR/*.otf)
for fonts in $otfs
do
	gftools fix-dsig --autofix $fonts
	gftools fix-weightclass $fonts
	[ -f $fonts.fix ] && mv $fonts.fix $fonts
done

##########################################

rm -rf instance_ufo/ *.ufo

echo ".
COMPLETE!
."
