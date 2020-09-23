#!/bin/sh
set -e
source ./env/bin/activate

VF_PATH=./fonts/variable/Trispace[wdth,wght].ttf

echo ".
MAKE UFO
."
rm -rf *.ufo
glyphs2ufo ./Sources/Trispace.glyphs --generate-GDEF
rm ./Sources/Trispace.designspace
mv ./Sources/Trispace-CondensedThin.ufo ./Sources/TrispaceCondensed-Thin.ufo
mv ./Sources/Trispace-ExpandedThin.ufo ./Sources/TrispaceExpanded-Thin.ufo
mv ./Sources/Trispace-CondensedExtraBold.ufo ./Sources/TrispaceCondensed-ExtraBold.ufo
mv ./Sources/Trispace-ExpandedExtraBold.ufo ./Sources/TrispaceExpanded-ExtraBold.ufo

##########################################

echo ".
GENERATING VARIABLE
."
rm -rf ./fonts/variable
mkdir -p ./fonts/variable

fontmake -m ./Sources/Trispace-variable.designspace -o variable --output-path $VF_PATH

##########################################

echo ".
POST-PROCESSING VF
."
vfs=$(ls $VF_PATH)
for vf in $vfs
do
	gftools fix-dsig --autofix $vf
	gftools fix-nonhinting $vf $vf.fix
	mv $vf.fix $vf
	gftools fix-unwanted-tables --tables MVAR $vf
done
rm ./fonts/variable/*gasp*

python gen_stat.py $VF_PATH

##########################################

rm -rf instance_ufo/ *.ufo

echo ".
COMPLETE!
."
