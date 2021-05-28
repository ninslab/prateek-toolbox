#!/bin/bash

################################################################################

# BiasCorrection

# Perform N4 Bias Correction for MRI Images using ANTs
# Input Folder(s)
#	00_InputImages - Contains Input Image Files
# Output Folder(s)
#	01_BiasCorrection - Contains Bias Corrected Image Files and Bias Fields

################################################################################

# Neuroimaging and Neurospectroscopy Laboratory
# National Brain Research Centre

################################################################################

# Contributors: Praful P. Pai, Tripti Goel
# Revised By: Praful P. Pai
# Revised On: 13.06.2018

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

# Log Results to File and Terminal
mkdir -p $srcDir/LogFiles
exec > >(tee -i $srcDir/LogFiles/LogFile_BiasCorrection.txt)

# Formatting Output
echo
echo N4 Bias Correction using ANTs
echo -----------------------------
echo
echo "Performing N4 Bias Correction for T1-weighted and GRE Magnitude Images."
echo

# Image Dimension for Bias Correction
imgDim=3

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

	# Specify Input and Output Folder Paths
    inputImageFolder=$srcDir/$folderName/00_InputImages
	biasCorrectedFolder=$srcDir/$folderName/01_BiasCorrection
	
	# Make Folders for Bias Corrected and Bias Field Image Files
	mkdir -p $biasCorrectedFolder

	# Extract T1-weighted Image File Name	
	fileName=${folderName}_T1w
	
    # Format Output
    echo
	echo "Performing Bias Correction on T1-weighted Image from Subject $currFolder of $numFolders."
	echo
	
	# Specify Input and Output Files
	inputImageFile=$inputImageFolder/$fileName.nii
	biasCorrectedFile=$biasCorrectedFolder/${fileName}_N4Corrected.nii.gz
	biasFieldFile=$biasCorrectedFolder/${fileName}_N4BiasField.nii.gz
	
	# Log Command to Text File
	echo N4BiasFieldCorrection \
	-d $imgDim \
	-i $inputImageFile \
	-o [$biasCorrectedFile,$biasFieldFile] \
	-v 1 >> $srcDir/LogFile.txt \

	# Command Line to ANTs
	N4BiasFieldCorrection \
	-d $imgDim \
	-i $inputImageFile \
	-o [$biasCorrectedFile,$biasFieldFile] \
	-v 1 \

	# Format Output    
    echo
    echo "Completed Bias Correction on T1-weighted Image from Subject $currFolder of $numFolders."
	echo
	
	# Extract GRE Magnitude Image File Name	
	fileName=${folderName}_GREMag
	
    # Format Output
    echo
	echo "Performing Bias Correction on GRE Magnitude Image from Subject $currFolder of $numFolders."
	echo
	
	# Specify Input and Output Files
	inputImageFile=$inputImageFolder/$fileName.nii
	biasCorrectedFile=$biasCorrectedFolder/${fileName}_N4Corrected.nii.gz
	biasFieldFile=$biasCorrectedFolder/${fileName}_N4BiasField.nii.gz
	
	# Log Command to Text File
	echo N4BiasFieldCorrection \
	-d $imgDim \
	-i $inputImageFile \
	-o [$biasCorrectedFile,$biasFieldFile] \
	-v 1 >> $srcDir/LogFile.txt \

	# Command Line to ANTs
	N4BiasFieldCorrection \
	-d $imgDim \
	-i $inputImageFile \
	-o [$biasCorrectedFile,$biasFieldFile] \
	-v 1 \

	# Format Output    
    echo
    echo "Completed Bias Correction on GRE Magnitude Image from Subject $currFolder of $numFolders."
	echo
	
done

echo
echo "Completed N4 Bias Correction for T1-weighted and GRE Magnitude Images."
echo

# EoF
