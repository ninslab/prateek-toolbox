#!/bin/bash

################################################################################

# ImageDenoising

# Perform Image Denoising for MRI Images using ANTs
# Input Folder(s)
#	01_BiasCorrection - Contains Intensity Inhomogeneity Corrected Image Files
# Output Folder(s)
#	02_ImageDenoising - Contains Denoised Image Files and Noise Field Images

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
exec > >(tee -i $srcDir/LogFiles/LogFile_ImageDenoising.txt)

# Formatting Output
echo
echo Image Denoising using ANTs
echo --------------------------
echo
echo "Performing Image Denoising for Bias Corrected Input MRI Files."
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
	biasCorrectedFolder=$srcDir/$folderName/01_BiasCorrection
	denoisedImageFolder=$srcDir/$folderName/02_ImageDenoising
	
	# Make Folders for Image Denoising and Noise Field Image Files
	mkdir -p $denoisedImageFolder

	# Extract T1-weighted Bias Corrected Image File	
	fileName=$(ls $biasCorrectedFolder/*T1w*N4Corrected*)
	
	# Extract File Name
    fileName=${fileName%%.*}
    fileName=${fileName##*/}
    
    # Format Output
    echo
	echo "Performing Image Denoising on T1-weighted Image from Subject $currFolder of $numFolders."
	echo
	
	# Specify Input and Output Files
	biasCorrectedFile=$biasCorrectedFolder/$fileName.nii.gz
	denoisedImageFile=$denoisedImageFolder/${fileName}_Denoised.nii.gz
	noiseFieldFile=$denoisedImageFolder/${fileName}_NoiseField.nii.gz
	
	# Log Command to Text File
    echo DenoiseImage \
    -d $imgDim \
    -n Rician \
    -i $biasCorrectedFile \
    -o [$denoisedImageFile,$noiseFieldFile] \
    -v 1 >> $srcDir/LogFile.txt \
	
	# Command Line to ANTs
    DenoiseImage \
    -d $imgDim \
    -n Rician \
    -i $biasCorrectedFile \
    -o [$denoisedImageFile,$noiseFieldFile] \
    -v 1 \
	
	# Format Output
    echo
    echo "Completed Image Denoising on T1-weighted Image from Subject $currFolder of $numFolders."
	echo

	# Extract T1-weighted Bias Corrected Image File	
	fileName=$(ls $biasCorrectedFolder/*GREMag*N4Corrected*)
	
	# Extract File Name
    fileName=${fileName%%.*}
    fileName=${fileName##*/}
    
    # Format Output
    echo
	echo "Performing Image Denoising on GRE Magnitude Image from Subject $currFolder of $numFolders."
	echo
	
	# Specify Input and Output Files
	biasCorrectedFile=$biasCorrectedFolder/$fileName.nii.gz
	denoisedImageFile=$denoisedImageFolder/${fileName}_Denoised.nii.gz
	noiseFieldFile=$denoisedImageFolder/${fileName}_NoiseField.nii.gz
	
	# Log Command to Text File
    echo DenoiseImage \
    -d $imgDim \
    -n Rician \
    -i $biasCorrectedFile \
    -o [$denoisedImageFile,$noiseFieldFile] \
    -v 1 >> $srcDir/LogFile.txt \
	
	# Command Line to ANTs
    DenoiseImage \
    -d $imgDim \
    -n Rician \
    -i $biasCorrectedFile \
    -o [$denoisedImageFile,$noiseFieldFile] \
    -v 1 \
	
	# Format Output
    echo
    echo "Completed Image Denoising on GRE Magnitude Image from Subject $currFolder of $numFolders."
	echo
	
done

echo
echo "Completed Image Denoising for T1-weighted and GRE Magnitude Images."
echo

# EoF
