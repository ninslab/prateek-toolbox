## Rearrangement of files in QSM

################################################################################

# Neuroimaging and Neurospectroscopy Laboratory
# National Brain Research Centre

################################################################################

# Contributors: Anshika Goel
# Revised By: Anshika Goel
# Revised On: 10.06.2019

################################################################################


# Read options for instructions

while getopts a:q: Options;
	do
	case "$Options" in
	
	# Option a - Specify Source Folder Location
	a)	# Read Source Folder Location
		sDir=$OPTARG
		echo "Option -a used. Source Folder: $OPTARG"      
		;;
		
     # Option q - Specify File / Folder Prefix
	q)	# Read Number of Characters to Retain
		nE=$OPTARG
		echo "Option -q used. Retaining $nE Echo Folder."
		;;

    esac
done

echo "Copying the files to output folder."

echo srcDir=$sDir
srcDir=$sDir

# mkdir -p $srcDir/LogFiles
# exec > >(tee -i $srcDir/LogFiles/LogFile_Rearrange2.txt)

    echo OutputImageFolder=$srcDir/QSM/02_ProcessedEchoImages
    
    OutputImageFolder=$srcDir/QSM/02_ProcessedEchoImages
    
    echo mv $PWD/Phase_2pi* $OutputImageFolder/Echo_$nE/Phase_2pi_$nE.nii
    echo mv $PWD/Laplacian* $OutputImageFolder/Echo_$nE/Laplacian_$nE.nii
    echo mv $PWD/Unwrapped* $OutputImageFolder/Echo_$nE/Unwrapped_Phase_$nE.nii
    echo mv $PWD/TissuePhase* $OutputImageFolder/Echo_$nE/TissuePhase_$nE.nii
    echo mv $PWD/NewMask* $OutputImageFolder/Echo_$nE/NewMask_$nE.nii
    echo mv $PWD/Susceptibility* $OutputImageFolder/Echo_$nE/QSM_$nE.nii
    
    
    mv $PWD/Phase_2pi* $OutputImageFolder/Echo_$nE/Phase_2pi_$nE.nii      
    mv $PWD/Laplacian* $OutputImageFolder/Echo_$nE/Laplacian_$nE.nii
    mv $PWD/Unwrapped* $OutputImageFolder/Echo_$nE/Unwrapped_Phase_$nE.nii
    mv $PWD/TissuePhase* $OutputImageFolder/Echo_$nE/TissuePhase_$nE.nii
    mv $PWD/NewMask* $OutputImageFolder/Echo_$nE/NewMask_$nE.nii
    mv $PWD/Susceptibility* $OutputImageFolder/Echo_$nE/QSM_$nE.nii
    
    rm $PWD/Mag*
    rm $PWD/Mask*
    rm $PWD/Phase*   

#EoF
