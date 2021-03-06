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

# Find Number of Cores
numCores=$(nproc)

# Log Results to File and Terminal
mkdir -p $srcDir/LogFiles
exec > >(tee -i $srcDir/LogFiles/LogFile_ImageLabeling_Freesurfer.txt)

# Formatting Output
echo
echo Image Labeling using Freesurfer
echo -------------------------------
echo
echo "Performing Labelling of T1-weighted Images using Freesurfer."
echo

# Specify Temporary Image Folder for Image Labeling
tempImageLabelingFolder=$srcDir/tempImageLabeling_FS

# Make Folders for Image Labeling
mkdir -p $tempImageLabelingFolder

echo
echo "Copying T1-weighted Linearly Registered Images."
echo

# Folder Prefix
fPrefix=HU

# Find Number of Folders and Initiate Current Folder Count
numFolders=$(ls $srcDir/$fPrefix* -d -1 | wc -l)
currFolder=00

for folders in $srcDir/$fPrefix* ; do
    
    # Current File Count
    currFolder=$((currFolder+1))

    # Extract File Name
    folderName=${folders%%.*}
    folderName=${folderName##*/}

	# Specify Input Image Folder Path
	inputImageFolder=$srcDir/$folderName/03_ImageRegistration
	labeledImageFolder=$srcDir/$folderName/05_ImageLabeling_FS
	
	# Make Folders for Skull Stripping
	mkdir -p $labeledImageFolder

	# Extract T1-weighted Skull Stripped Image File	
	fileName=$(ls $inputImageFolder/*T1w*_Warped*)
	
	# Extract File Name
    fileName=${fileName%%.*}
    fileName=${fileName##*/}
    
    # Copy File to Temporary Image Labeling Folder
    cp $inputImageFolder/$fileName.nii.gz $tempImageLabelingFolder/

done

echo
echo "Completed Copying T1-weighted Linearly Registered Images."
echo

# Unzip Compressed Image Files
gunzip $tempImageLabelingFolder/*.nii.gz

echo
echo "Processsing T1-weighted Images using Freesurfer."
echo

# Initialize Freesurfer
export SUBJECTS_DIR=$tempImageLabelingFolder/

# Log Command to Text File
echo ls $tempImageLabelingFolder/*.nii | parallel --jobs $numCores recon-all -s {.} -i {} -all -qcache >> $srcDir/LogFile.txt

# Command Line to Freesurfer
ls $tempImageLabelingFolder/*.nii | parallel --jobs $numCores recon-all -s {.} -i {} -all -qcache

echo
echo "Completed Processsing of T1-weighted Images using Freesurfer."
echo

# Initiate Current Folder Count
currFolder=00

for folders in $srcDir/$fPrefix* ; do
    
    # Current File Count
    currFolder=$((currFolder+1))

    # Extract File Name
    folderName=${folders%%.*}
    folderName=${folderName##*/}

	# Extract Image File	
	fName=$(ls $tempImageLabelingFolder/$folderName*.nii)

    # Extract File Name
    fName=${fName%%.*}
    fName=${fName##*/}
    
	# Specify Input Image Folder Path
	imageLabelsFolder=$tempImageLabelingFolder/$fName
	labeledImageFolder=$srcDir/$folderName/05_ImageLabeling_FS
	
	# Copy Freesurfer Generated Files
	cp -r $imageLabelsFolder/* $labeledImageFolder/

done

# Removing Temporary Image Folder for Image Labeling
rm -r $tempImageLabelingFolder

# EoF
