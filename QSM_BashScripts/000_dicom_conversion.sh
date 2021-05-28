## Conversion of dicom files and rearranging them


################################################################################

# Neuroimaging and Neurospectroscopy Laboratory
# National Brain Research Centre

################################################################################

###############################################################################

# Contributors: Anshika Goel
# Created on: 23.05.2019
# Revised On: 03.07.2019

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
# mkdir -p $srcDir/LogFiles
# exec > >(tee -i $srcDir/LogFiles/LogFile_dicom_conversion.txt)

# Initiate Current File Count
numFolders=$(ls $srcDir/$fPrefix* -d -1 | wc -l)
currFolder=00

for folders in $srcDir/$fPrefix* ; do

     # Current File Count 
    echo currFolder=$((currFolder+1))
    
    currFolder=$((currFolder+1))
     
    echo folderName=${folders%%.*}
    echo folderName=${folderName##*/}
    
    
    # Extract File Name
    folderName=${folders%%.*}
    folderName=${folderName##*/}

    # Specify Folder Paths
    MainFolder=$srcDir/$folderName/QSM
    InputImageFolder=$MainFolder/01_InputImages
    OutputImageFolder=$MainFolder/02_ProcessedEchoImages
        
    mkdir -p $MainFolder
    mkdir -p $InputImageFolder
    mkdir -p $OutputImageFolder
       
    
    mv $srcDir/$folderName/QSM/DICOM $InputImageFolder/
 
       
    # Specify subFolder Paths
    DicomImageFolder=$InputImageFolder/DICOM
    NiftiImageFolder=$InputImageFolder/Nifti
    T1ImageFolder=$InputImageFolder/T1

    
    mkdir -p $NiftiImageFolder
    mkdir -p $T1ImageFolder
    
    ## Move T1 image to T1Image Folder
    mv $srcDir/$folderName/MRI/T1/HU*T1* $T1ImageFolder
    
    echo
    echo
    echo $NiftiImageFolder
    echo
    
    echo "Converting DICOM image to Nifti Files"

    # echo dcm2niix -f %i %e -z y -o $NiftiImageFolder $DicomImageFolder >> $srcDir/LogFile.txt

    dcm2niix -f %i %e -z y -o $NiftiImageFolder $DicomImageFolder

    # Renaming Magnitude and Phase images and move to new folder

    echo1Folder=$NiftiImageFolder/Echo_1
    echo2Folder=$NiftiImageFolder/Echo_2
    echo3Folder=$NiftiImageFolder/Echo_3
    echo4Folder=$NiftiImageFolder/Echo_4
    echo5Folder=$NiftiImageFolder/Echo_5   
    
    mkdir -p $echo1Folder
    mkdir -p $echo2Folder
    mkdir -p $echo3Folder
    mkdir -p $echo4Folder
    mkdir -p $echo5Folder

    echo1_output=$OutputImageFolder/Echo_1
    echo2_output=$OutputImageFolder/Echo_2
    echo3_output=$OutputImageFolder/Echo_3
    echo4_output=$OutputImageFolder/Echo_4
    echo5_output=$OutputImageFolder/Echo_5   
    
    mkdir -p $echo1_output
    mkdir -p $echo2_output
    mkdir -p $echo3_output
    mkdir -p $echo4_output
    mkdir -p $echo5_output
    
    # Echo1
    mv $NiftiImageFolder/*e1.nii.gz $echo1Folder/Mag_e1.nii.gz
    mv $NiftiImageFolder/*e1.json $echo1Folder/Mag_e1.json
    
    mv $NiftiImageFolder/*e1_ph.nii.gz $echo1Folder/Phase_e1.nii.gz
    mv $NiftiImageFolder/*e1_ph.json $echo1Folder/Phase_e1.json
    
    mv $NiftiImageFolder/*e1_imaginary.nii.gz $echo1Folder/Im_e1.nii.gz
    mv $NiftiImageFolder/*e1_imaginary.json $echo1Folder/Im_e1.json
    
    mv $NiftiImageFolder/*e1_real.nii.gz $echo1Folder/Re_e1.nii.gz
    mv $NiftiImageFolder/*e1_real.json $echo1Folder/Re_e1.json

    # Echo2
    mv $NiftiImageFolder/*e2.nii.gz $echo2Folder/Mag_e2.nii.gz
    mv $NiftiImageFolder/*e2.json $echo2Folder/Mag_e2.json
    
    mv $NiftiImageFolder/*e2_ph.nii.gz $echo2Folder/Phase_e2.nii.gz
    mv $NiftiImageFolder/*e2_ph.json $echo2Folder/Phase_e2.json
    
    mv $NiftiImageFolder/*e2_imaginary.nii.gz $echo2Folder/Im_e2.nii.gz
    mv $NiftiImageFolder/*e2_imaginary.json $echo2Folder/Im_e2.json
    
    mv $NiftiImageFolder/*e2_real.nii.gz $echo2Folder/Re_e2.nii.gz
    mv $NiftiImageFolder/*e2_real.json $echo2Folder/Re_e2.json
    
    # Echo 3
    mv $NiftiImageFolder/*e3.nii.gz $echo3Folder/Mag_e3.nii.gz
    mv $NiftiImageFolder/*e3.json $echo3Folder/Mag_e3.json
    
    mv $NiftiImageFolder/*e3_ph.nii.gz $echo3Folder/Phase_e3.nii.gz
    mv $NiftiImageFolder/*e3_ph.json $echo3Folder/Phase_e3.json
    
    mv $NiftiImageFolder/*e3_imaginary.nii.gz $echo3Folder/Im_e3.nii.gz
    mv $NiftiImageFolder/*e3_imaginary.json $echo3Folder/Im_e3.json
    
    mv $NiftiImageFolder/*e3_real.nii.gz $echo3Folder/Re_e3.nii.gz
    mv $NiftiImageFolder/*e3_real.json $echo3Folder/Re_e3.json
    
    # Echo 4
    mv $NiftiImageFolder/*e4.nii.gz $echo4Folder/Mag_e4.nii.gz
    mv $NiftiImageFolder/*e4.json $echo4Folder/Mag_e4.json
    
    mv $NiftiImageFolder/*e4_ph.nii.gz $echo4Folder/Phase_e4.nii.gz
    mv $NiftiImageFolder/*e4_ph.json $echo4Folder/Phase_e4.json
    
    mv $NiftiImageFolder/*e4_imaginary.nii.gz $echo4Folder/Im_e4.nii.gz
    mv $NiftiImageFolder/*e4_imaginary.json $echo4Folder/Im_e4.json
    
    mv $NiftiImageFolder/*e4_real.nii.gz $echo4Folder/Re_e4.nii.gz
    mv $NiftiImageFolder/*e4_real.json $echo4Folder/Re_e4.json
    
    # Echo 5
    mv $NiftiImageFolder/*e5.nii.gz $echo5Folder/Mag_e5.nii.gz
    mv $NiftiImageFolder/*e5.json $echo5Folder/Mag_e5.json
    
    mv $NiftiImageFolder/*e5_ph.nii.gz $echo5Folder/Phase_e5.nii.gz
    mv $NiftiImageFolder/*e5_ph.json $echo5Folder/Phase_e5.json
    
    mv $NiftiImageFolder/*e5_imaginary.nii.gz $echo5Folder/Im_e5.nii.gz
    mv $NiftiImageFolder/*e5_imaginary.json $echo5Folder/Im_e5.json
    
    mv $NiftiImageFolder/*e5_real.nii.gz $echo5Folder/Re_e5.nii.gz
    mv $NiftiImageFolder/*e5_real.json $echo5Folder/Re_e5.json 
    
echo
echo "Completed Conversion of DICOM to Nifti files"
echo
  
done
