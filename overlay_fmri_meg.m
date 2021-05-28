function overlay_fmri_meg(initialDir)

key1 = 'Subjects';
key2 = 'Results';
key3 = 'Analysis.nii'; % fMRI mask
key4 = 'MEG';

subjectdir_init = fullfile(initialDir, key1);
subjectdir = dir(subjectdir_init);
len = length(subjectdir);

for i=3:len
    
    primarysub = subjectdir(i).name;
    resfolderdir = fullfile(subjectdir_init,primarysub,key2);
    fMRImask = fullfile(resfolderdir,key3);
    MEGmaskinit = dir(fullfile(subjectdir_init,primarysub,key4,'*spmeeg_*.nii'));
    MEGmask = fullfile(MEGmaskinit.folder, MEGmaskinit.name);
    
    % Masks of the both modalities
    %------------------------------------------------------------
    mask1 = niftiread(fMRImask);
    mask_meg = niftiread(MEGmask);
    
    % Information of Masks of both modalities
    %------------------------------------------------------------
    fMRIinfo = niftiinfo(fMRImask);
    MEGinfo = niftiinfo(MEGmask);
    
    % Count Overlaid Voxels
    %---------------------------------------------------------------------------------
    mask_2 = mask_meg;
    overlapImage = mask1 & mask_2;
    over = uint8(overlapImage);
    numOverlapPixels = nnz(overlapImage);
    niftiwrite(over,'overlappedROI.nii',fMRIinfo);
    movefile('overlappedROI.nii', resfolderdir);
    
    % Percentage Overlap
    %---------------------------------------------------------------------------------
    CR = (numOverlapPixels/((nnz(mask1) + nnz(mask_2))-numOverlapPixels)) * 100;
    disp(CR);
    
    % save in text File
    %---------------------------------------------------------------------------------
    fileID = fopen('percentage_overlap.txt','w');
    fprintf(fileID,'Overlap Percentage : \n\n');
    fprintf(fileID,'%d',CR);
    fclose(fileID);
    movefile('percentage_overlap.txt',resfolderdir);
    
end
end