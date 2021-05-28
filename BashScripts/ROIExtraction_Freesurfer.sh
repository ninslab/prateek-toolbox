#!/bin/bash

################################################################################

# ROIExtraction_Freesurfer

# Extract ROIs from T1-weighted MRI Images using Freesurfer
# Input Folder(s)
#	05_ImageLabeling_FS - Contains Image Label Files Generated using Freesurfer
# Output Folder(s)
#	06_ROIExtraction_FS - Contains Files Used and Generated during ROI Extraction

################################################################################

# Neuroimaging and Neurospectroscopy Laboratory
# National Brain Research Centre

################################################################################

# Contributors: Praful P. Pai, Tripti Goel
# Revised By: Praful P. Pai
# Revised On: 19.06.2018

################################################################################

# Read Options for Execution
while getopts a:l: Options;
	do
	case "$Options" in
	
	# Option a - Specify Source Folder Location
	a)	# Read Source Folder Location
		sDir=$OPTARG
		echo "Option -a used. Source Folder: $OPTARG"      
		;;
	
	# Option l - Specify ROI Extraction Labels
	l)	# Read Label Value
		labelValue=$OPTARG
		echo "Option -l used. Label Value: $OPTARG"      
		case "$labelValue" in

		4) # Specify Label Name
			 labelName=LeftLateralVentricle
			 ;;
		
		5) # Specify Label Name
			 labelName=LeftInfLatVentricle
			 ;;
		
		7) # Specify Label Name
			 labelName=LeftCerebellumWM
			 ;;
		
		8) # Specify Label Name
			 labelName=LeftCerebellumCortex
			 ;;
			 		
		10) # Specify Label Name
			 labelName=LeftThalamus
			 ;;
		
		11) # Specify Label Name
			 labelName=LeftCaudate
			 ;;
		
		12) # Specify Label Name
			 labelName=LeftPutamen
			 ;;
		
		13) # Specify Label Name
			 labelName=LeftPallidum
			 ;;
			 
		14) # Specify Label Name
			 labelName=ThirdVentricle
			 ;;
		
		15) # Specify Label Name
			 labelName=FourthVentricle
			 ;;
		
		16) # Specify Label Name
			 labelName=BrainStem
			 ;;
			 
		17) # Specify Label Name
			 labelName=LeftHippocampus
			 ;;
		
		18) # Specify Label Name
			 labelName=LeftAmygdala
			 ;;
		
		24) # Specify Label Name
			 labelName=CSF
			 ;;
		
		26) # Specify Label Name
			 labelName=LeftAccumbensArea
			 ;;
		
		28) # Specify Label Name
			 labelName=LeftVentralDC
			 ;;
		
		30) # Specify Label Name
			 labelName=LeftVessel
			 ;;
			 		
		31) # Specify Label Name
			 labelName=LeftChoroidPlexus
			 ;;
		
		43) # Specify Label Name
			 labelName=RightLateralVentricle
			 ;;
		
		44) # Specify Label Name
			 labelName=RightInfLatVentricle
			 ;;
		
		46) # Specify Label Name
			 labelName=RightCerebellumWM
			 ;;
			 
		47) # Specify Label Name
			 labelName=RightCerebellumCortex
			 ;;
			 
		49) # Specify Label Name
			 labelName=RightThalamus
			 ;;
		
		50) # Specify Label Name
			 labelName=RightCaudate
			 ;;

		51) # Specify Label Name
			 labelName=RightPutamen
			 ;;

		52) # Specify Label Name
			 labelName=RightPallidum
			 ;;

		53) # Specify Label Name
			 labelName=RightHippocampus
			 ;;

		54) # Specify Label Name
			 labelName=RightAmygdala
			 ;;
			 
		58) # Specify Label Name
			 labelName=RightAccumbensArea
			 ;;
		
		60) # Specify Label Name
			 labelName=RightVentralDC
			 ;;
		
		62) # Specify Label Name
			 labelName=RightVessel
			 ;;
			 		
		63) # Specify Label Name
			 labelName=RightChoroidPlexus
			 ;;

		72) # Specify Label Name
			 labelName=FifthVentricle
			 ;;
		
		85) # Specify Label Name
			 labelName=OpticChiasma
			 ;;
		
		251) # Specify Label Name
			 labelName=CorpusCallosumPosterior
			 ;;
			 		
		252) # Specify Label Name
			 labelName=CorpusCallosumMidPosterior
			 ;;
		
		253) # Specify Label Name
			 labelName=CorpusCallosumCentral
			 ;;
			 		
		254) # Specify Label Name
			 labelName=CorpusCallosumMidAnterior
			 ;;

		255) # Specify Label Name
			 labelName=CorpusCallosumAnterior
			 ;;
			 
		esac
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
exec > >(tee -i $srcDir/LogFiles/LogFile_ROIExtraction_Freesurfer.txt)

# Formatting Output
echo
echo ROI Extraction using Freesurfer Output
echo --------------------------------------
echo
echo "Performing ROI Extraction of $labelName using Freesurfer Outputs."
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

	# Specify Image Folder Paths
	inputImageFolder=$srcDir/$folderName/00_InputImages
	labeledImageFolder=$srcDir/$folderName/05_ImageLabeling_FS
	extractedROIFolder=$srcDir/$folderName/06_ROIExtraction_FS

	# Make Folders for ROI Extractiom Outputs
	mkdir -p $extractedROIFolder
	
	# Convert Segmentation File to NIfTI Format
	echo mri_convert -rl $labeledImageFolder/mri/rawavg.mgz -rt nearest $labeledImageFolder/mri/aseg.mgz $extractedROIFolder/aseg2raw.nii >> $srcDir/LogFile.txt
	mri_convert -rl $labeledImageFolder/mri/rawavg.mgz -rt nearest $labeledImageFolder/mri/aseg.mgz $extractedROIFolder/aseg2raw.nii
	
	echo
	echo "Completed Conversion of Segmentation File to NIfTI Format."
	echo
	
	# Apply Thresholds on Segmentation File to Extract Mask
	echo fslmaths $extractedROIFolder/aseg2raw.nii -uthr $labelValue -thr $labelValue $extractedROIFolder/$labelName.nii.gz >> $srcDir/LogFile.txt
	fslmaths $extractedROIFolder/aseg2raw.nii -uthr $labelValue -thr $labelValue $extractedROIFolder/$labelName.nii.gz
	
	echo
	echo "Completed Thresholding of Segmentation File."
	echo
	
	# Divide Thresholded Segmentation Image by Label Value to Obtain ROI Extraction Mask
	echo fslmaths $extractedROIFolder/$labelName.nii.gz -div $labelValue $extractedROIFolder/${labelName}_Mask.nii.gz >> $srcDir/LogFile.txt
	fslmaths $extractedROIFolder/$labelName.nii.gz -div $labelValue $extractedROIFolder/${labelName}_Mask.nii.gz
	
	echo
	echo "Completed Mask Generation from Segmentation File."
	echo
	
	# Apply Generated ROI Mask to QSM Image
	echo mri_mask $inputImageFolder/${folderName}_QSM.nii $extractedROIFolder/${labelName}_Mask.nii.gz $extractedROIFolder/${folderName}_QSM_${labelName}.nii.gz >> $srcDir/LogFile.txt
	mri_mask $inputImageFolder/${folderName}_QSM.nii $extractedROIFolder/${labelName}_Mask.nii.gz $extractedROIFolder/${folderName}_QSM_${labelName}.nii.gz
	
	echo
	echo "Completed Application of Segmentation Mask to QSM Image."
	echo
		
	# Compute Mean of QSM Image in ROI
	echo fslmeants -i $extractedROIFolder/${folderName}_QSM_${labelName}.nii.gz -o $extractedROIFolder/${folderName}_QSM_${labelName}.txt >> $srcDir/LogFile.txt
	meanQSMValue=$(fslmeants -i $extractedROIFolder/${folderName}_QSM_${labelName}.nii.gz)
	
	echo "$labelName, $meanQSMValue" >> $extractedROIFolder/${folderName}_ROIMeanQSMValues.csv

	echo
	echo "Completed Computation of Average QSM Intensity."
	echo
	
done

echo
echo "Completed ROI Extraction and Processing of $labelName from QSM Image."
echo

# EoF
