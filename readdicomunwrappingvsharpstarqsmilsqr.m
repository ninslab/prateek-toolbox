function readdicomunwrappingvsharpstarqsmilsqr(workingdir,checkb0val)

addpath('bet2');
direc = workingdir;
B0 = checkb0val;

direc1 = strcat(direc, '/Subjects');
cont = dir(direc1);
num = length(cont);

for i = 3:num
    
    huname = cont(i).name;
    file = strcat(direc1 ,'/', huname , '/DICOM');
    [iField,iMag,iPhase,voxel_size,matrix_size,CF,delta_TE,TE,B0_dir,files]=Read_DICOM_Philips_3D_new(file);
    [iFreq_raw,N_std] = Fit_ppm_complex(iField);
    iMag = sqrt(sum(abs(iField).^2,4));
    currentSlice = round(matrix_size(3));
    nSlices = matrix_size(3);
    imageDataM = iMag;
    imageDataP = iFreq_raw;
    imageDataMOriginal = imageDataM;
    imageDataPOriginal = imageDataP;
    valWin = double(max(imageDataPOriginal(:)) - min(imageDataPOriginal(:)));
    valWin (valWin < 1) = 1;
    valLvl = double(min(imageDataPOriginal(:)) + (valWin/2));
    [minRange,maxRange] = WL2R(valWin,valLvl);
    
    orig = cd;
    currentDirectory = strcat(direc1, '/', huname);
    cd(currentDirectory);
    niftiwrite(iMag, 'Magnitude_QSM');
    cd(orig);
    system(['bash ./BashScripts/MaskCreation_BET.sh -a ' currentDirectory])
    cd(currentDirectory);
    a = niftiread('Magnitude_QSM_BET_Brain_Mask');
    cd(orig);
    Mask = double(a);
    disp('Mask')
    save Mask Mask
    Mag = imageDataM;
    save Mag Mag
    PhaseData = imageDataP;
    save PhaseData PhaseData
    
    voxelsize = [0.9978 0.9978 2];
    H = [ 0.0041 0.3193 0.9536 ];
    len = length(TE);
    
    for h = 1:len
        mkdir([currentDirectory,'/','Echo_Data','/','Echo',int2str(h) ]);
    end
    
    for j = 1: len
        TE_sum = TE(j);
        [Unwrapped_Phase, Laplacian]=MRPhaseUnwrap(PhaseData,'voxelsize',voxelsize);
        [TissuePhase,NewMask]=V_SHARP(Unwrapped_Phase,Mask,'voxelsize',voxelsize);
        [Susceptibility]= QSM_star(TissuePhase,NewMask,'TE',TE_sum,'B0',B0,'H',H,'voxelsize',voxelsize);
        [Susceptibility_1]= QSM_iLSQR(TissuePhase,NewMask,'TE',TE_sum,'B0',B0,'H',H,'voxelsize',voxelsize);

        
        cd(currentDirectory);
        
        niftiwrite(Mask, 'Mask_File');
        niftiwrite(Unwrapped_Phase , 'Unwrapped_Phase');
        niftiwrite(Laplacian, 'Laplacian');
        niftiwrite(TissuePhase, 'TissuePhase');
        niftiwrite(NewMask, 'New_Mask');
        niftiwrite(Susceptibility, 'Susceptibility_Star_Final_QSM_Image');
        niftiwrite(Susceptibility_1, 'Susceptibility_iLSQR_Final_QSM_Image');
        destfolder = strcat(currentDirectory,'/Echo_Data/','Echo',num2str(j));
        
        str1 = strcat(currentDirectory, '/Mask_File.nii');
        str2 = strcat(currentDirectory, '/Unwrapped_Phase.nii');
        str3 = strcat(currentDirectory, '/Laplacian.nii');
        str4 = strcat(currentDirectory, '/TissuePhase.nii');
        str5 = strcat(currentDirectory, '/New_Mask.nii');
        str6 = strcat(currentDirectory, '/Susceptibility_Star_Final_QSM_Image.nii' );
        str7 = strcat(currentDirectory, '/Susceptibility_iLSQR_Final_QSM_Image.nii');
        
        movefile(str1, destfolder);
        movefile(str2, destfolder);
        movefile(str3, destfolder);
        movefile(str4, destfolder);
        movefile(str5, destfolder);
        movefile(str6, destfolder);
        movefile(str7, destfolder);
        
        cd(orig);
        
    end
    h = msgbox('Operation Completed');
    
end



end