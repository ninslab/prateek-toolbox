function saveproc22(dir_value)

key1 = 'Subjects';
key2 = 'Results';

subjectdir_init = fullfile(dir_value, key1);
subjectdir = dir(subjectdir_init);
len = length(subjectdir);

for i=3:len
    primarysub = subjectdir(i).name;
    maskdata = fullfile(subjectdir_init,primarysub,key2);
    
    % MEG mask
    megmaskinit = dir(fullfile(maskdata, '*spmeeg_*'));
    megmask = fullfile(megmaskinit.folder, megmaskinit.name);
    
    % MRS mask
    mrsmaskinit = dir(fullfile(maskdata, '*_mask_norm.nii'));
    mrsmask = fullfile(mrsmaskinit.folder, mrsmaskinit.name);
    
    % masking
    mask_meg = niftiread(megmask);
    mask_mrs = niftiread(mrsmask);
    meginfo = niftiinfo(megmask);
    mrsinfo = niftiinfo(mrsmask);
    
    mask_2 = mask_meg;
    overlapImage = mask_mrs & mask_2;
    over = uint8(overlapImage);
    numOverlapPixels = nnz(overlapImage);
    
    % Additional Later
    mrsinfo.Datatype = 'uint8';
    
    niftiwrite(over, 'overlappedROI.nii', mrsinfo);
    movefile('overlappedROI.nii',maskdata);
    
    % overlap
    CR = (numOverlapPixels/((nnz(mask_mrs) + nnz(mask_2))-numOverlapPixels)) * 100;
    disp(CR);
    
    % write in txt file
    fileID = fopen('percentage_overlap.txt','w');
    fprintf(fileID,'Overlap Percentage : \n\n');
    fprintf(fileID,'%d', CR);
    fclose(fileID);
    movefile('percentage_overlap.txt',maskdata);
    
end
end