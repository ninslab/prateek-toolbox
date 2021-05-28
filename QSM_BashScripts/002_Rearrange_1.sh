## Rearrangement of files in QSM

###############################################################################

# Contributors: Anshika Goel
# Created on: 23.05.2019
# Revised On: 03.07.2019

################################################################################


# Read options for instructions

while getopts a:q: Options;
	do
	case "$Options" in
	
	# Option a - Specify Source Folder Location
	# Option q - Specify File / Folder Prefix

	a)	# Read Source Folder Location
		sDir=$OPTARG
		echo "Option -a used. Source Folder: $OPTARG"      
		;;
		
    q)	# Read Echo No. to extract particular folder
		nE=$OPTARG
		echo "Option -q used. Retaining $nE Echo Folder."
		;;
	 
		
    # Unspecified Option
	\?)	# Issue an Error Message
		echo "Invalid Option: -$OPTARG" >&2
		# exit 0
		;;
    	   
    esac
done

echo "Started rearranging the files"
echo ""

echo srcDir=$sDir
srcDir=$sDir

# mkdir -p $srcDir/LogFiles
# exec > >(tee -i $srcDir/LogFiles/LogFile_Rearrangement.txt)


    echo InputImageFolder=$srcDir/QSM/01_InputImages/Nifti
    echo OutputImageFolder=$srcDir/QSM/02_ProcessedEchoImages
    
    InputImageFolder=$srcDir/QSM/01_InputImages/Nifti
    OutputImageFolder=$srcDir/QSM/02_ProcessedEchoImages
    
    echo
    echo
    echo cp $InputImageFolder/Echo_$nE/Mag*.nii* $PWD/Mag.nii.gz
    echo cp $InputImageFolder/Echo_$nE/Phase*.nii* $PWD/Phase.nii.gz
    echo cp $OutputImageFolder/Echo_$nE/Mask* $PWD/Mask.nii.gz
    echo
    echo
    
    cp $InputImageFolder/Echo_$nE/Mag*.nii* $PWD/Mag.nii.gz
    cp $InputImageFolder/Echo_$nE/Phase*.nii* $PWD/Phase.nii.gz
    cp $OutputImageFolder/Echo_$nE/Mask* $PWD/Mask.nii.gz
  
#EoF   
