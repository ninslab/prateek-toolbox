#!/bin/bash

################################################################################

# LinearRegistrationToQSM

# Perform Registration of T1 MRI Images to GRE Magnitude Images
# Input Folder(s)
#	02_ImageDenoising - Contains Denoised Image Files and Noise Field Images
# Output Folder(s)
#	03_ImageRegistration - Contains Linearly Registered Image Files

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
exec > >(tee -i $srcDir/LogFiles/LogFile_LinearRegistration.txt)

# Formatting Output
echo
echo Linear Registration - 6 DoF using ANTs
echo --------------------------------------
echo
echo "Performing Linear Image Registration of T1-weighted and GRE Magnitude Image Files."
echo

# Initialize ANTs for Linear Registration
numCores=$(nproc)	# Number of Cores
imgDim=3			# Image Dimension

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
	denoisedImageFolder=$srcDir/$folderName/02_ImageDenoising
	registeredImageFolder=$srcDir/$folderName/03_ImageRegistration
	
	# Make Folders for Linear Registration
	mkdir -p $registeredImageFolder

	# Extract T1-weighted Bias Corrected Image File
	fileName=$(ls $denoisedImageFolder/*T1w*Denoised*)
    fileName=${fileName%%.*}
    fileName=${fileName##*/}
    
    movingImage=$fileName
    
	# Extract GRE Magnitude Image File
	fileName=$(ls $denoisedImageFolder/*GREMag*Denoised*)
    fileName=${fileName%%.*}
    fileName=${fileName##*/}

    fixedImage=$fileName
    
    # Format Output
    echo
	echo "Registering T1-weighted Image to GRE Magnitude Image from Subject $currFolder of $numFolders."
	echo
	
	# Specify Fixed and Moving Image Files
	fixedImageFile=$denoisedImageFolder/$fixedImage.nii.gz
	movingImageFile=$denoisedImageFolder/$movingImage.nii.gz
	outputImageFile=$registeredImageFolder/${movingImage}_RegToQSM_
	
	# Log Command to Text File
	echo antsRegistrationSyN.sh \
	-d $imgDim \
	-f $fixedImageFile \
	-m $movingImageFile \
	-o $outputImageFile \
	-t r \
	-j 1 \
	-n $numCores >> $srcDir/LogFile.txt \
	
	antsRegistrationSyN.sh \
	-d $imgDim \
	-f $fixedImageFile \
	-m $movingImageFile \
	-o $outputImageFile \
	-t r \
	-j 1 \
	-n $numCores \
	
	# Format Output
	echo
    echo "Completed Registration of T1-weighted Image to GRE Magnitude Image from Subject $currFolder of $numFolders."
	echo
	
done

echo
echo "Completed Linear Registration (6 DoF) of T1-weighted Images to GRE Magnitude Images."
echo

# EoF
