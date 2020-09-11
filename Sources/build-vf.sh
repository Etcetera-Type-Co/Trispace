#!/bin/sh
set -e
source ../env/bin/activate

VF_PATH=../fonts/variable/Trispace[wdth,wght].ttf

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
GENERATING VARIABLE
."
rm -rf ../fonts/variable
mkdir -p ../fonts/variable

fontmake -m Trispace-variable.designspace -o variable --output-path $VF_PATH

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
rm ../fonts/variable/*gasp*

python gen_stat.py $VF_PATH

##########################################

rm -rf instance_ufo/ *.ufo

echo ".
COMPLETE!
."
