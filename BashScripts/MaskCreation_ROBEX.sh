#!/bin/bash

################################################################################

# MaskCreation_ROBEX

# Perform Brain Extracion using ROBEX on QSM Magnitude Image Files
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
outputBrainImage=$srcDir/Magnitude_QSM_ROBEX_Brain.nii.gz
outputMaskImage=$srcDir/Magnitude_QSM_ROBEX_Mask.nii.gz
	
# Change to ROBEX Installation Directory
cd $ROBEXPATH

# Command Line to ROBEX
./ROBEX $inputImage $outputBrainImage $outputMaskImage
	
# Format Output
echo
echo "Completed Skull Stripping QSM Magnitude Image."
echo

# EoF
