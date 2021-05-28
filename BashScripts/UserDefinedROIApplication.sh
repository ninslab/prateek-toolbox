#!/bin/bash

################################################################################

# UserDefinedROIApplication

# Apply User Defined Masks to QSM Images
# Input Folder(s)
#   00_InputImages - Contains Input T1, GREMag and QSM Image Files
#	03_ImageRegistration - Contains Linearly Registered Image Files
#	UserDefinedROIs - Contains User-Defined Mask Files and Associated Files
# Output Folder(s)
#	06_ROIExtraction_UD - Contains Files Used and Generated during ROI Extraction

################################################################################

# Neuroimaging and Neurospectroscopy Laboratory
# National Brain Research Centre

################################################################################

# Contributors: Praful P. Pai, Tripti Goel
# Revised By: Praful P. Pai
# Revised On: 26.06.2018

################################################################################

# Read Options for Execution
while getopts a:i:l: Options;
	do
	case "$Options" in
	
	# Option a - Specify Source Folder Location
	a)	# Read Source Folder Location
		sDir=$OPTARG
		echo "Option -a used. Source Folder: $OPTARG"      
		;;
	
	# Option i - Specify ROI Extraction Label Location
	i)	# Read ROI File Locations
		locationROI=$OPTARG
		echo "Option -i used. ROI Folder: $OPTARG"
		;;
		
	# Option l - Specify ROI Extraction Labels
	l)	# Read Label Value
		labelValue=$OPTARG
		echo "Option -l used. Label Value: $OPTARG"
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
exec > >(tee -i $srcDir/LogFiles/LogFile_ROIExtraction_UserDefined.txt)

# Formatting Output
echo
echo User Defined ROI Extraction
echo ---------------------------
echo
echo "Performing User Defined ROI Extraction in $labelValue."
echo

# Folder Prefix
fPrefix=HU

# ANTs Parameters
imgDim=3		# Image Dimension
numCores=$(nproc)	# Number of Cores

# Find Number of Folders and Initiate Current Folder Count
numFolders=$(ls $srcDir/$fPrefix* -d -1 | wc -l)
currFolder=00

for folders in $srcDir/$fPrefix* ; do
    
    # Current File Count
    currFolder=$((currFolder+1))

    # Extract File Name
    folderName=${folders%%.*}
    folderName=${folderName##*/}
    
    # Specify Image Folder Paths
    inputImageFolder=$srcDir/$folderName/00_UserDefinedROIs
    referenceImageFolder=$srcDir/$folderName/03_ImageRegistration
    extractedROIFolder=$srcDir/$folderName/06_ROIExtraction_UD
    
    # Make Folders for ROI Extractiom Outputs
    mkdir -p $inputImageFolder
    mkdir -p $extractedROIFolder
    
    # Copy ROI and Associated Files to Created Folder
    cp $locationROI/*T1*.nii $inputImageFolder/${folderName}_T1w_ROI.nii
    cp $locationROI/*$labelValue*.nii $inputImageFolder/${folderName}_ROI_${labelValue}_Mask.nii
    
    # Register ROI T1-weighted Image to QSM Registered T1-weighted Image
    
	# Format Output
	echo
    echo "Registering T1-weighted Mask Image to QSM Registered T1-weighted Image."
	echo
    
    # Specify Input and Output Files
    fixedImage=$(ls $referenceImageFolder/*T1*_Warped.nii.gz)
    movingImage=$(ls $inputImageFolder/*T1*.nii)
    outputImage=$extractedROIFolder/${folderName}_T1w_${labelValue}_
    
    # Log Command to Text File
	echo antsRegistrationSyN.sh \
	-d $imgDim \
	-f $fixedImage \
	-m $movingImage \
	-o $outputImage \
	-t r \
	-j 1 \
	-n $numCores >> $srcDir/LogFile.txt \
	
	antsRegistrationSyN.sh \
	-d $imgDim \
	-f $fixedImage \
	-m $movingImage \
	-o $outputImage \
	-t r \
	-j 1 \
	-n $numCores

	# Format Output
	echo
    echo "Completed Registering T1 Mask Image to QSM Registered T1 Image."
	echo
	
	# Format Output
	echo
    echo "Apply Transform to Mask File."
	echo
	
    # Specify Input and Output Files
    inputImage=$(ls $inputImageFolder/*$labelValue*.nii)
    referenceImage=$(ls $referenceImageFolder/*T1*_Warped.nii.gz)
    transformFile=$extractedROIFolder/${folderName}_T1w_${labelValue}_0GenericAffine.mat
    outputImage=$extractedROIFolder/${folderName}_${labelValue}_RegToQSM.nii
	
    # Log Command to Text File
	echo antsApplyTransforms \
	-d $imgDim \
	-i $inputImage \
	-r $referenceImage \
	-t $transformFile \
	-o $outputImage >> $srcDir/LogFile.txt \
	
	antsApplyTransforms \
	-d $imgDim \
	-i $inputImage \
	-r $referenceImage \
	-t $transformFile \
	-o $outputImage \
    
    # Format Output
	echo
    echo "Completed Transformation of Mask File."
	echo
    
    inputQSMImageFolder=$srcDir/$folderName/00_InputImages
    
    # Specify Input and Output Files
    inputImage=$(ls $inputQSMImageFolder/*QSM*.nii)
    maskImage=$outputImage
    outputImage=$extractedROIFolder/${folderName}_${labelValue}_QSMRegion.nii.gz
	
	# Apply Transformed ROI Mask to QSM Image
	echo mri_mask $inputImage $maskImage $outputImage >> $srcDir/LogFile.txt
	mri_mask $inputImage $maskImage $outputImage >> $srcDir/LogFile.txt
	
	echo
	echo "Completed Application of Segmentation Mask to QSM Image."
	echo
	
	# Specify Input and Output Files
	maskedQSMImage=$outputImage
		
	# Compute Mean of QSM Image in ROI
	echo fslmeants -i $maskedQSMImage -o $extractedROIFolder/${folderName}_QSM_${labelValue}.txt >> $srcDir/LogFile.txt
	fslmeants -i $maskedQSMImage -o $extractedROIFolder/${folderName}_QSM_${labelValue}.txt >> $srcDir/LogFile.txt

	echo
	echo "Completed Computation of Average QSM Intensity."
	echo
	
done

echo
echo "Completed ROI Extraction and Processing of $labelValue from QSM Image."
echo

# EoF
