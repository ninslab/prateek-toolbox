function results_file_folder_fmri_mrs(subject_dir,subject_code,string)

% Prefix
%--------
region = string;
key1 = 'MRS';
key2 = 'Results';

len = length(subject_dir);

% Save mask
%-----------
for i= 1:len
    primarysubdir = subject_dir(i);
    resultsfolder = char(fullfile(primarysubdir,key2));
    mkdir(resultsfolder);
    mrsfiledir = fullfile(primarysubdir, key1, region);
    mrsfilestring = strcat(region,'_mask_norm.nii');
    mrsfile = char(fullfile(mrsfiledir, mrsfilestring));
    copyfile(mrsfile, resultsfolder);
end

end