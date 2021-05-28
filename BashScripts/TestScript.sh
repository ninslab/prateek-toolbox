#!/bin/bash

################################################################################

# ImageLabeling_Freesurfer

# Perform Labelling of T1-weighted MRI Images using Freesurfer
# Input Folder(s)
#	04_SkullStripping_ROBEX - Contains Skull-Stripped Files Generated using ROBEX
# Output Folder(s)
#	05_ImageLabeling_FS - Contains Image Label Files Generated using Freesurfer

################################################################################

# Neuroimaging and Neurospectroscopy Laboratory
# National Brain Research Centre

################################################################################

# Contributors: Praful P. Pai, Tripti Goel
# Revised By: Praful P. Pai
# Revised On: 19.06.2018

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

# Folder Prefix
fPrefix=HU

# Specify Temporary Image Folder for Image Labeling
tempImageLabelingFolder=$srcDir/tempImageLabeling_FS

for folders in $srcDir/$fPrefix* ; do
    
    # Current File Count
    currFolder=$((currFolder+1))

    # Extract File Name
    folderName=${folders%%.*}
    folderName=${folderName##*/}

	# Extract Image File	
	fName=$(ls -d $tempImageLabelingFolder/$folderName*)

    # Extract File Name
    fName=${fName%%.*}
    fName=${fName##*/}
    
	# Specify Input Image Folder Path
	imageLabelsFolder=$tempImageLabelingFolder/$fName
	labeledImageFolder=$srcDir/$folderName/05_OriginalImageLabeling_FS
	
	# Copy Freesurfer Generated Files
	cp -r $imageLabelsFolder/* $labeledImageFolder/

done

