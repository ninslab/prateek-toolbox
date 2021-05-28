#!/bin/bash

################################################################################

# RearrangeFiles

# Rename MRI Image Files in the Input Dataset as per a Default Naming Scheme

# Input Folder(s)
#	SourceFolder - Contains Input MRI Image Datasets
# Output Folder(s)
#	00_OriginalImageDataset - Contains Original Input Image Dataset
#	00_OriginalFiles - Contains Original Input Image Files of a Subject
#	00_InputImages - Contains Input (T1, GREMag and QSM) Images of a Subject

################################################################################

# Neuroimaging and Neurospectroscopy Laboratory
# National Brain Research Centre

################################################################################

# Contributors: Praful P. Pai, Tripti Goel
# Revised By: Praful P. Pai
# Revised On: 13.06.2018

################################################################################

# Read Options for Execution
while getopts a:r:s: Options;
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
		
	# Option s - File Suffix - Image Sequence
	s)  # Specify File Suffix
		sType=$OPTARG
		case "$sType" in
		
		# Option T1
		T1) # Specify File Name Suffix
			 fNameSuffix=T1w
			 ;;
		
		# Option T2
		T2) # Specify File Name Suffix
			 fNameSuffix=T2w
			 ;;
			 		
		# Option FA
		FA) # Specify File Name Suffix
			 fNameSuffix=FLAIR
			 ;;
		
		# Option GE Magnitude
		GM) # Specify File Name Suffix
			 fNameSuffix=GREMag
			 ;;
		
		# Option GE Magnitude
		QS) # Specify File Name Suffix
			 fNameSuffix=QSM
			 ;;				
		
		esac
		echo "Option -s used. Adding Suffix $fNameSuffix to Filenames."
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
exec > >(tee -i $srcDir/LogFiles/LogFile_RearrangeFiles.txt)

# Specify Folder Paths
originalImageDataFolder=$srcDir/00_OriginalImageDataset

# Make Folder for Input Files and Move Files
mkdir -p $originalImageDataFolder

# Folder Prefix
fPrefix=HU

# Initiate Current File Count
numFolders=$(ls $srcDir/$fPrefix* -d -1 | wc -l)
currFolder=00

# Rename Input Image Files
for folders in $srcDir/$fPrefix* ; do
    
    # Current File Count
    currFolder=$((currFolder+1))

    # Extract File Name
    folderName=${folders%%.*}
    folderName=${folderName##*/}
	
	echo
	echo "Copying Files to Backup Directory."
	echo
	
	# Copy Files to Backup Directory
	cp -r $srcDir/$folderName $originalImageDataFolder/$folderName
	
	# Format Output
	echo "Renaming Folder $currFolder of $numFolders."
	echo "Current Folder Name: $folderName"
	
	if [ "$rFlag" = "1" ]
    then
    
		# Generate File Number and File Name
		printf -v fNum "%04d" $currFolder
		fNameNew=HU${fNum}
		
		# Format Output
    	echo "New Folder Name: $fNameNew"

    else
		
		# Generate File Name by Retaining Characters    	
		fNameNew=${folderName:0:nChar}
		
		# Format Output
    	echo "New Folder name: $fNameNew"
    	    	
    fi
	
	# New Folder Name for Subject
	newFolderName=$srcDir/$fNameNew
	
	echo
	echo "Renaming Folder $currFolder and Generating CSV File of Records"
	echo
	
   	# Rename Folders and Generate CSV
   	mv $srcDir/$folderName $newFolderName
   	echo "$folderName, $fNameNew" >> $srcDir/SubjectIDs.csv
    	
    # Specify Folder Paths in Each Subject Directory
	originalFileDataFolder=$newFolderName/00_OriginalFiles
	inputFileDataFolder=$newFolderName/00_InputImages
	
	# Make Folder for Input Files and Move Files
	mkdir -p $originalFileDataFolder
	mkdir -p $inputFileDataFolder
    
	echo
	echo "Making a Copy of Original Files for Folder $currFolder - $fNameNew"
	echo
    
    # Copy Original Files in Folder to Backup Location
    cp $newFolderName/* $originalFileDataFolder/
    
    cd $newFolderName/

   	# Generate CSV of File Names
	echo "$(find $fNameNew*T1*.nii), ${fNameNew}_T1w.nii" >> $newFolderName/${fNameNew}_Files.csv
	echo "$(find $fNameNew*GREMag*.nii), ${fNameNew}_GREMag.nii" >> $newFolderName/${fNameNew}_Files.csv
	echo "$(find $fNameNew*QSM*.nii), ${fNameNew}_QSM.nii" >> $newFolderName/${fNameNew}_Files.csv
    
	echo
	echo "Renaming T1, GREMag and QSM Files in Folder $currFolder - $fNameNew"
	echo
	
    # Rename T1-weigted, GREMag, and QSM Files
    mv $newFolderName/$fNameNew*T1*.nii $inputFileDataFolder/${fNameNew}_T1w.nii
    mv $newFolderName/$fNameNew*GREMag*.nii $inputFileDataFolder/${fNameNew}_GREMag.nii
    mv $newFolderName/$fNameNew*QSM*.nii $inputFileDataFolder/${fNameNew}_QSM.nii
	
	echo
	echo "Completed Rearrangement of Folder $currFolder of $numFolders"
	echo
		
done

# Format Output
echo
echo "Completed Folder and File Reorganization."
echo

