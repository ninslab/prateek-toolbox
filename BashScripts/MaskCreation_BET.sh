#!/bin/bash

################################################################################

# MaskCreation_BET

# Perform Brain Extracion using BET on QSM Magnitude Image Files
# Input Folder(s)
#	QSM Base Folder - Contains QSM Magnitude Image File
# Output Folder(s)
#	QSM Base Folder - Contains Skull Stripped QSM Magnitude Image and Mask File

################################################################################

# Neuroimaging and Neurospectroscopy Laboratory
# National Brain Research Centre

################################################################################

# Contributors: Praful P. Pai, Saurav Roy
# Revised By: Praful P. Pai
# Revised On: 12.11.2018

################################################################################

# Read Options for Execution
while getopts a: Options;
	do
	case "$Options" in
	
	# Option a - Specify Source Folder Location
	a)	# Read Source Folder Location
		sDir=$OPTARG
		echo "Option -a used. Source Folder: $OPTARG"      
		;;

	# Unspecified Option
	\?)	# Issue an Error Message
		echo "Invalid Option: -$OPTARG" >&2
		# exit 0
		;;
    
    esac
done

# Select Source Folder
srcDir=$sDir

# Format Output
echo
echo "Skull Stripping QSM Magnitude Image."
echo
	
# Specify Input and Output Files
inputImage=$srcDir/Magnitude_QSM.nii
outputBrainImage=$srcDir/Magnitude_QSM_BET
outputMaskImage=$srcDir/Magnitude_QSM_BET_Mask.nii.gz
	
# Command Line to FSL - BET
fsl5.0-bet $inputImage $outputBrainImage -f 0.5 -m -R -v

# Rename Output Mask Image
mv $srcDir/Magnitude_QSM_BET_mask.nii.gz $outputMaskImage

# Format Output
echo
echo "Completed Initial Skull Stripping Run on QSM Magnitude Image."
echo "Computing Center-of-Gravity of QSM Magnitude Image."
echo

# Find CoG Voxel Coordinates using FSL
corrCoG=$(fsl5.0-fslstats $outputMaskImage -C)
	
# Use CoG for Skull Stripping
#fsl5.0-bet $outputBrainImage.nii.gz ${outputBrainImage}_Brain -c $corrCoG -f 0.5 -m -R -v
fsl5.0-bet $inputImage ${outputBrainImage}_Brain -c $corrCoG -f 0.5 -m -R -v

# Rename Output Mask Image
mv ${outputBrainImage}_Brain_mask.nii.gz ${outputBrainImage}_Brain_Mask.nii.gz

# Format Output
echo
echo "Completed Second Skull Stripping Run on QSM Magnitude Image."
echo

# EoF
