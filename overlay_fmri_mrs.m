function overlay_fmri_mrs(initialDir)

key1 = 'Subjects';
key2 = 'Results';
key3 = 'Analysis.nii'; % fMRI mask
key4 = '_mask_norm.nii'; % MRS mask

subjectdir_init = fullfile(initialDir, key1);
subjectdir = dir(subjectdir_init);
len = length(subjectdir);

for i= 3 : len
    
    primarysub = subjectdir(i).name;
    resfolderdir = fullfile(subjectdir_init,primarysub,key2);
    fMRImask = fullfile(resfolderdir,key3);
    MRSmaskinit = dir(fullfile(resfolderdir,'*_mask_norm.nii'));
    MRSmask = fullfile(MRSmaskinit.folder, MRSmaskinit.name);
    
    % Masks of the both modalities
    %------------------------------------------------------------
    mask1 = niftiread(fMRImask);
    mask_2 = niftiread(MRSmask);
    
    % Information of Masks of both modalities
    %------------------------------------------------------------
    fMRIinfo = niftiinfo(fMRImask);
    MRSinfo = niftiinfo(MRSmask);
    
    % Count Overlaid Voxels
    %---------------------------------------------------------------------------------
    mask2 = uint8(mask_2);
    overlapImage = mask1 & mask2;
    over = uint8(overlapImage);
    numOverlapPixels = nnz(overlapImage);
    niftiwrite(over,'overlappedROI.nii', fMRIinfo);
    movefile('overlappedROI.nii', resfolderdir);
    
    % Percentage Overlap
    %---------------------------------------------------------------------------------
    CR = (numOverlapPixels/((nnz(mask1) + nnz(mask2))-numOverlapPixels)) * 100;
    disp(CR);
    
    % save in text File
    %---------------------------------------------------------------------------------
    fileID = fopen('percentage_overlap.txt','w');
    fprintf(fileID,'Overlap Percentage : \n\n');
    fprintf(fileID,'%d', CR);
    fclose(fileID);
    movefile('percentage_overlap.txt',resfolderdir);
    
end
end