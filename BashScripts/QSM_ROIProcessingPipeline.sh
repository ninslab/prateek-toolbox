#!/bin/bash

################################################################################

# QSM_ROIProcessingPipeline

# Perform Processing of QSM ROI Processing Pipeline
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
# Revised On: 14.06.2018

################################################################################

# Read Options for Execution
while getopts a:l:r: Options;
	do
	case "$Options" in
	
	# Option a - Specify Source Folder Location
	a)	# Read Source Folder Location
		sDir=$OPTARG
		echo "Option -a used. Source Folder: $OPTARG"      
		;;

	# Option l - Specify Label Options for ROI Extraction
	l)	# Read Label for ROI Extraction
		lOption=$OPTARG
		case "$lOption" in
		
		# Option 0 - Process All Labels
		0) # Process All Labels
			 lValue=(10 11 12 13 17 18 49 50 51 52 53 54)
			 ;;
		
		# Process Specified Label
		*) # Specify File Name Suffix
			 lValue=$lOption
			 ;;				
		
		esac
		echo "Option -l used. Extracting ROIs for Processing."
		;;
	
	# Option r - Specify File Organization Options. Rename Files or Retain Characters.
	r)	# Read Number of Characters to Retain
		nChar=$OPTARG
		echo "Option -r used. Retaining Characters or Renaming Files."
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
exec > >(tee -i $srcDir/LogFiles/LogFile_QSM_ROIProcessingPipeline.txt)

# Formatting Output
echo
echo ---------------------------
echo QSM ROI Processing Pipeline
echo ---------------------------
echo
echo "Performing QSM ROI Processing."

# Call Individual Scripts
bash RearrangeFiles.sh -a $srcDir -r $nChar
bash BiasCorrection.sh -a $srcDir
bash ImageDenoising.sh -a $srcDir
bash LinearRegistration.sh -a $srcDir
bash SkullStripping_ROBEX.sh -a $srcDir
bash ImageLabeling_Freesurfer.sh -a $srcDir

# Compute Number of Labels
numLabels=${#lValue[@]}

# Format Output
echo
echo "Number of Labels for Extraction:$numLabels"
echo

# Initialize Label Index
currLabel=0

# Process ROIs
while [ $currLabel -lt $numLabels ]; do
	
	# Format Output
	echo
	echo "Processing Label $currLabel."
	echo "Label Value ${lValue[$currLabel]}."
	echo

	bash ROIExtraction_Freesurfer.sh -a $srcDir -l ${lValue[$currLabel]}

	# Format Output
	echo
	echo "Completed Processing Label $currLabel."
	echo
	
	# Increment Label Index	
	currLabel=$((currLabel+1))

done

# Formatting Output
echo
echo "Completed QSM ROI Processing."
echo

# EoF
