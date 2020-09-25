#!/bin/sh
set -e
source ./env/bin/activate

OTF_DIR=./fonts/static/otf
TTF_DIR=./fonts/static/ttf
WEB_DIR=./fonts/web

echo ".
MAKE UFO
."
rm -rf ./Sources/*.ufo
glyphs2ufo ./Sources/Trispace.glyphs --generate-GDEF
rm ./Sources/Trispace.designspace
mv ./Sources/Trispace-CondensedThin.ufo ./Sources/TrispaceCondensed-Thin.ufo
mv ./Sources/Trispace-ExpandedThin.ufo ./Sources/TrispaceExpanded-Thin.ufo
mv ./Sources/Trispace-CondensedExtraBold.ufo ./Sources/TrispaceCondensed-ExtraBold.ufo
mv ./Sources/Trispace-ExpandedExtraBold.ufo ./Sources/TrispaceExpanded-ExtraBold.ufo

##########################################

echo ".
GENERATING STATICS
."
rm -rf $OTF_DIR $TTF_DIR
mkdir -p $OTF_DIR $TTF_DIR

fontmake -m ./Sources/Trispace-static.designspace -i -o ttf --output-dir $TTF_DIR
fontmake -m ./Sources/Trispace-static.designspace -i -o otf --output-dir $OTF_DIR

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

rm -rf ./Sources/instance_ufo/ ./Sources/*.ufo

echo ".
COMPLETE!
."
