#!/bin/bash

################################################################################

# SkullStripping_ROBEX

# Perform Brain Extracion using ROBEX on Pre-Processed T1 and MRI Image Files
# Input Folder(s)
#	03_ImageRegistration - Contains Linearly Registered Image Files
# Output Folder(s)
#	04_SkullStripping_ROBEX - Contains Skull-Stripped Files Generated using ROBEX

################################################################################

# Neuroimaging and Neurospectroscopy Laboratory
# National Brain Research Centre

################################################################################

# Contributors: Praful P. Pai, Tripti Goel
# Revised By: Praful P. Pai
# Revised On: 14.06.2018

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
exec > >(tee -i $srcDir/LogFiles/LogFile_SkullStripping_ROBEX.txt)

# Formatting Output
echo
echo Skull-Stripping using ROBEX
echo ---------------------------
echo
echo "Performing Skull Stripping using ROBEX for Image Files."
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

	# Specify Input and Output Folder Paths
	inputImageFolder=$srcDir/$folderName/00_InputImages
	denoisedImageFolder=$srcDir/$folderName/02_ImageDenoising
	registeredImageFolder=$srcDir/$folderName/03_ImageRegistration	
	skullstrippedImageFolder=$srcDir/$folderName/04_SkullStripping_ROBEX
		
	# Make Folders for Skull Stripping
	mkdir -p $skullstrippedImageFolder

	# Extract T1-weighted Bias Corrected Image File	
	fileName=$(ls $registeredImageFolder/*T1w*_Warped*)
	
	# Extract File Name
    fileName=${fileName%%.*}
    fileName=${fileName##*/}
    
	# Format Output
    echo
    echo "Skull Stripping Images from Subject $currFolder of $numFolders."
	echo

    # Format Output
    echo
	echo "Skull Stripping T1-weighted Image from Subject $currFolder of $numFolders."
	echo
	
	# Specify Input and Output Files
	inputImage=$registeredImageFolder/$fileName.nii.gz
	outputBrainImage=$skullstrippedImageFolder/${fileName}_ROBEX_Brain.nii.gz
	outputMaskImage=$skullstrippedImageFolder/${fileName}_ROBEX_Mask.nii.gz
	
	# Change to ROBEX Installation Directory
	cd $ROBEXPATH
	
	# Log Command to Text File
	echo ./ROBEX $inputImage $outputBrainImage $outputMaskImage >> $srcDir/LogFile.txt

	# Command Line to ROBEX
	./ROBEX $inputImage $outputBrainImage $outputMaskImage
	
	# Format Output
    echo
	echo "Completed Skull Stripping T1-weighted Image from Subject $currFolder of $numFolders."
	echo
	
	# Format Output
    echo
	echo "Skull Stripping GRE Magnitude Image from Subject $currFolder of $numFolders."
	echo

	# Extract Pre-processed GRE Magnitude Image File	
	fileName=$(ls $denoisedImageFolder/*GREMag*Denoised*)
	
	# Extract File Name
    fileName=${fileName%%.*}
    fileName=${fileName##*/}
    
	# Specify Input and Output Files
	inputImage=$denoisedImageFolder/$fileName.nii.gz
	outputImage=$skullstrippedImageFolder/${fileName}_ROBEX_Brain.nii.gz
		
	# Log Command to Text File
	echo mri_mask $inputImage $outputMaskImage $outputImage >> $srcDir/LogFile.txt
	
	# Command Line to Freesurfer
	mri_mask $inputImage $outputMaskImage $outputImage
	
	# Format Output
    echo
	echo "Completed Skull Stripping GRE Magnitude Image from Subject $currFolder of $numFolders."
	echo
	
	# Format Output
    echo
	echo "Skull Stripping QSM Image from Subject $currFolder of $numFolders."
	echo

	# Extract QSM Image File	
	fileName=$(ls $inputImageFolder/$folderName*QSM*)
	
	# Extract File Name
    fileName=${fileName%%.*}
    fileName=${fileName##*/}
    
	# Specify Input and Output Files
	inputImage=$inputImageFolder/$fileName.nii
	outputImage=$skullstrippedImageFolder/${fileName}_ROBEX_Brain.nii.gz
		
	# Log Command to Text File
	echo mri_mask $inputImage $outputMaskImage $outputImage >> $srcDir/LogFile.txt
	
	# Command Line to Freesurfer
	mri_mask $inputImage $outputMaskImage $outputImage
	
	# Format Output
    echo
	echo "Completed Skull Stripping QSM Image from Subject $currFolder of $numFolders."
	echo
	
	# Format Output
    echo
    echo "Completed Skull Stripping of Images from Subject $currFolder of $numFolders."
	echo
	
done

echo
echo "Completed Skull Stripping of Images."
echo

# EoF
