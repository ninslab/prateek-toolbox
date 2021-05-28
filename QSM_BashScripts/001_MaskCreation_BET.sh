#!/bin/bash

################################################################################

# MaskCreation_BET

# Perform Brain Extracion using BET on QSM Magnitude Image Files

################################################################################

# Neuroimaging and Neurospectroscopy Laboratory
# National Brain Research Centre

################################################################################

# Contributors: Praful P. Pai, Anshika Goel
# Revised By: Anshika Goel
# Revised On: 10.06.2019

################################################################################

# Read Options for Execution
while getopts a:r:p: Options;
	do
	case "$Options" in
	
	# Option a - Specify Source Folder Location
	a)	# Read Source Folder Location
		sDir=$OPTARG
		echo "Option -a used. Source Folder: $OPTARG"      
		;;
    
    # Option r - Rename Files or Retain Characters
	r)	# Read Number of Characters to Retain
		nChar=$OPTARG
		echo "Option -r used. Retaining Characters or Renaming Files."
		case "$nChar" in
		
		# Option 0 - Retain No Characters
		0) # Rename Files
		     echo "Option -r used. Retaining $nChar Characters. Renaming Files."
		     rFlag="1"
			 ;;
		
		# Option n - Retain Characters
		\?) # Read Number of Characters to Retain
		     echo "Option -r used. Retaining Initial $nChar Characters."
		     rFlag="0"
			 ;;

		esac
		;;
		
	# Option p - Specify File / Folder Prefix
	p)	# Read File / Folder Prefix
		fPrefix=HU
		fPrefix=$OPTARG
		echo "Option -p used. File Prefix: $OPTARG"      
		;;
			
    	# Option p - Specify File / Folder Prefix
	s)	# Read File / Folder Prefix
		ePrefix=Echo
		ePrefix=$OPTARG
		echo "Option -s used. Echo Folder Prefix: $OPTARG"      
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

# Initiate Current File Count
echo numFolders=$(ls $srcDir/$fPrefix* -d -1 | wc -l)
echo currFolder=00

numFolders=$(ls $srcDir/$fPrefix* -d -1 | wc -l)
currFolder=00

for folders in $srcDir/$fPrefix* ; do

    currFolder=$((currFolder+1))
    
    echo folderName=${folders%%.*}
    echo folderName=${folderName##*/}
    
    folderName=${folders%%.*}
    folderName=${folderName##*/}
    
    echo EchoFolder=$srcDir/$folderName/QSM/01_InputImages/Nifti
    EchoFolder=$srcDir/$folderName/QSM/01_InputImages/Nifti
    
    OutputEchoFolder=$srcDir/$folderName/QSM/02_ProcessedEchoImages
    
    # Initiate Current File Count
    echo numFolders=$(ls $EchoFolder/$ePrefix* -d -1 | wc -l)
    echo curr1Folder=00
    
    numFolders=$(ls $EchoFolder/$ePrefix* -d -1 | wc -l)
    curr1Folder=00
    
    for folders in $EchoFolder/$ePrefix* ; do
        
        curr1Folder=$((curr1Folder+1))
        
        echo folder1Name=${folders%%.*}
        echo folder1Name=${folder1Name##*/}
        
        folder1Name=${folders%%.*}
        folder1Name=${folder1Name##*/}
	
        # Specify Input and Output Files
        echo inputImage=$EchoFolder/$folder1Name/Mag_e*.nii*
        echo outputBrainImage=$EchoFolder/$folder1Name/Mag_QSM_BET
        echo outputMaskImage=$EchoFolder/$folder1Name/Mag_QSM_BET_Mask.nii.gz
        
        inputImage=$EchoFolder/$folder1Name/Mag_e*.nii*
        outputBrainImage=$EchoFolder/$folder1Name/Mag_QSM_BET
        outputMaskImage=$EchoFolder/$folder1Name/Mag_QSM_BET_Mask.nii.gz
	
        # Command Line to FSL - BET
        bet $inputImage $outputBrainImage -f 0.5 -m -R -v

        # Rename Output Mask Image
        mv $EchoFolder/$folder1Name/Mag_QSM_BET_mask.nii.gz $outputMaskImage

        # Format Output
        echo
        echo "Completed Initial Skull Stripping Run on QSM Magnitude Image."
        echo "Computing Center-of-Gravity of QSM Magnitude Image."
        echo

        # Find CoG Voxel Coordinates using FSL
        corrCoG=$(fslstats $outputMaskImage -C)
	
        # Use CoG for Skull Stripping
        #fsl5.0-bet $outputBrainImage.nii.gz ${outputBrainImage}_Brain -c $corrCoG -f 0.5 -m -R -v
        bet $inputImage ${outputBrainImage}_Brain -c $corrCoG -f 0.5 -m -R -v

        # Rename Output Mask Image
        mv ${outputBrainImage}_Brain_mask.nii.gz $OutputEchoFolder/$folder1Name/Mask.nii.gz
        
        rm -r $EchoFolder/$folder1Name/Mag_QSM*

        # Format Output
        echo
        echo "Completed Second Skull Stripping Run on QSM Magnitude Image."
        echo

    done
done

# EoF
