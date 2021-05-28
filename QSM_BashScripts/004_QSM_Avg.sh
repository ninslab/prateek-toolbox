#!/bin/bash

################################################################################

# QSM_Avg

# Perform Averaging QSM output of all the 5 Echoes

################################################################################

# Neuroimaging and Neurospectroscopy Laboratory
# National Brain Research Centre

################################################################################

# Contributors: Anshika Goel
# Created On: 13.06.2019
# Revised on: 03.07.2019

################################################################################

# Read Options for Execution

while getopts a:s: Options;
	do
	case "$Options" in
	
	# Option a - Specify Source Folder Location
	a)	# Read Source Folder Location
		sDir=$OPTARG
		echo "Option -a used. Source Folder: $OPTARG"      
		;;
		
		
    	# Option s- Specify File / Folder Prefix
	s)	# Read File / Folder Prefix
		ePrefix=Echo
		ePrefix=$OPTARG
		echo "Option -s used. Echo Folder Prefix: $OPTARG"      
		;;

    esac
done


echo
echo "Averaging the echoes of QSM output files"
echo

echo srcDir=$sDir
srcDir=$sDir

# mkdir -p $srcDir/LogFiles
# exec > >(tee -i $srcDir/LogFiles/LogFile_QSM_Avg.txt)
  
    Echo_Input=$srcDir/QSM/01_InputImages/Nifti
    EchoFolder=$srcDir/QSM/02_ProcessedEchoImages
    AvgFolder=$EchoFolder/QSM/Average_Echoes
    
    mkdir -p $AvgFolder
    
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
        echo QSM_Image=$EchoFolder/$folder1Name/QSM*
                
        Mag_Image=$Echo_Input/$folder1Name/Mag*.nii*
        QSM_Image=$EchoFolder/$folder1Name/QSM*
        
        cp $QSM_Image $AvgFolder
        cp $Mag_Image $AvgFolder
        
    done
    
AverageImages 3 $AvgFolder/Avg_Echoes.nii 0 $AvgFolder/QSM*
AverageImages 3 $AvgFolder/Avg_Mag.nii.gz 0 $AvgFolder/Mag*
   
