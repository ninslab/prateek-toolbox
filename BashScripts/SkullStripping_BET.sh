#!/bin/bash

################################################################################

# SkullStripping_BET

# Perform Brain Extracion using FSL on Pre-Processed MRI Image Files
# Input Folder(s)
#	03_ACPC_Aligned - Contains AC PC Aligned MRI Files
# Output Folder(s)
#	08_SS_BET - Contains Skull-Stripped Files Generated using FSL-BET
#	08_SS_BET_Mask - Contains Skull-Stripping Masks Generated using FSL-BET
#	08_SS_BET_Extras - Contains Additional Files Generated during Skull-Stripping

################################################################################

# Indian Brain Template Project
# National Brain Research Centre

################################################################################

# Contributors: Ritu Lahoti, Praful P. Pai
# Revised By: Praful P. Pai
# Revised On: 27.03.2018

################################################################################

# Read Options for Execution
while getopts a: Options;
	do
	case "$Options" in
	
	# Option a - Specify Source Folder Location
	a)	# Read Source Folder Location
		sDir=$OPTARG
		echo "Option -a used. Source Folder: $sDir"      
		;;
		
	# Unspecified Option
	\?)	# Issue an Error Message
		echo "Invalid Option: -$OPTARG" >&2
		# exit 0
		;;
		
    esac
done

# Select Source Folder
srcDir=$sDir;

# Log Results to File and Terminal
mkdir -p $srcDir/LogFiles
exec > >(tee -i $srcDir/LogFiles/LogFile_SkullStripping_FSL.txt)

# Specify Input and Output Folder Paths
alignedACPCFolder=$srcDir/03_ACPC_Aligned
ssBETOutputFolder=$srcDir/08_SS_BET
ssBETMaskFolder=$srcDir/08_SS_BET_Mask
ssBETExtrasFolder=$srcDir/08_SS_BET_Extras

# Make Folders for Transfering Skull Stripped Files
mkdir -p $ssBETOutputFolder
mkdir -p $ssBETMaskFolder
mkdir -p $ssBETExtrasFolder

# Formatting Output
echo
echo Skull Stripping using BET
echo -------------------------
echo
echo "Performing Skull Stripping using Brain Extraction Toolbox - BET"
echo
echo "Input AC-PC Aligned Image File Path: "$alignedACPCFolder/
echo "Output BET Skull Stripped Output File Path: "$ssBETOutputFolder/
echo "Output BET Skull Stripped Mask File Path: "$ssBETMaskFolder/
echo "Output BET Skull Stripping Extras File Path: "$ssBETExtrasFolder/

# Count Number of Files and Initiate Current File Count
numFiles=$(ls $alignedACPCFolder/*.nii.gz -1 | wc -l)
currFile=00

# Read Bias Corrected, Denoised, and AC PC Aligned Images
# Perform Skull Stripping using FSL-BET
for files in $alignedACPCFolder/*.nii.gz ; do
		
	# Current File Count
    currFile=$((currFile+1))
    
    # Extract File Name
    fileName=${files%%.*}
    fileName=${fileName##*/}
    
    # Format Output
    echo
	echo "Performing Skull Stripping and Brain Extraction using FSL-BET."
	echo "Reading File No. $currFile: $fileName.nii.gz"
	echo
	
	# Specify Input and Output Files
	ssBETOutExt=_BET
	inputImage=$alignedACPCFolder/$fileName.nii.gz
	outputBrainImage=$ssBETOutputFolder/$fileName$ssBETOutExt
	outputMaskImage=$ssBETOutputFolder/$fileName${ssBETOutExt}_mask.nii.gz
	renamedMaskImage=$ssBETExtrasFolder/$fileName${ssBETOutExt}_Mask.nii.gz
	
	# Log Command to Text File
	echo fsl5.0-bet \
	$inputImage \
	$outputBrainImage \
	-f 0.5 \
	-m -R -v >> $srcDir/LogFile.txt \
	
	# Command Line to FSL - BET
	fsl5.0-bet \
	$inputImage \
	$outputBrainImage \
	-f 0.5 \
	-m -R -v \
	
	# Rename Output Mask Image
    mv $outputMaskImage $renamedMaskImage
	
	# Specify File Names
    finalOutputBrainImage=${outputBrainImage}_Brain

    # Format Output
    echo
	echo "Finding Centre-of-Gravity (CoG) using FSL and Skull-Stripping."
	echo "Reading File No. $currFile: $fileName$ssBETMaskExt.nii.gz"
	echo	
    
	# Log Command to Text File
	echo corrCoG=$(fsl5.0-fslstats $renamedMaskImage -C) >> $srcDir/LogFile.txt
	echo fsl5.0-bet \
	$outputBrainImage.nii.gz \
	$finalOutputBrainImage \
	-c $corrCoG \
	-f 0.5 \
	-m -R -v >> $srcDir/LogFile.txt \
	
	# Find CoG Voxel Coordinates using FSL
	corrCoG=$(fsl5.0-fslstats $renamedMaskImage -C)
	
	# Use CoG for Skull Stripping
	fsl5.0-bet \
	$outputBrainImage.nii.gz \
	$finalOutputBrainImage \
	-c $corrCoG \
	-f 0.5 \
	-m -R -v \
	
	# Rename Output Mask Image
	finalOutputMaskImage=${finalOutputBrainImage}_Mask.nii.gz
	mv ${finalOutputBrainImage}_mask.nii.gz $finalOutputMaskImage

    # Format Output
    echo
	echo "Completed Skull-Stripping of File No. $currFile of $numFiles."
	echo	

done

# Move Supplementary Images
mv $ssBETOutputFolder/*_Mask.nii.gz $ssBETMaskFolder/
mv $ssBETOutputFolder/*_BET.nii.gz $ssBETExtrasFolder/

# EoF
