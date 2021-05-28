function filestructcheck12(dir_value)

prefix_main = 'Subjects';
prefix_mri = 'MRI';
prefix_fmri = 'fMRI';
prefix_raw = 'Raw';
prefix_analysis = 'Analysis';
prefix_epi = 'EPI';

dir_updated = fullfile(dir_value,prefix_main);

% parse subjects
subjects = dir(dir_updated);
num = length(subjects);

for i = 3:num
    
    filename = subjects(i).name;
    filename_dir = fullfile(dir_updated,filename);
    filecheck1_mri = fullfile(filename_dir,prefix_mri);
    filecheck1_fmri = fullfile(filename_dir, prefix_fmri);
    
    if (exist(filecheck1_fmri,'dir'))&&(exist(filecheck1_mri,'dir')) == 7
        % Folder are in order
        % Proceed further
        
        % Check fMRI folder
        filecheck2_fmri_raw = fullfile(filecheck1_fmri,prefix_raw);
        filecheck2_fmri_epi = fullfile(filecheck1_fmri, prefix_epi);
        filecheck2_fmri_analysis = fullfile(filecheck1_fmri, prefix_analysis);
        
        if (exist(filecheck2_fmri_raw,'dir'))&&(exist(filecheck2_fmri_epi,'dir'))&&(exist(filecheck2_fmri_analysis,'dir')) == 7
            % Folder are in order
            % Proceed further
            disp('OK');
        else
            msgbox('Error in Folder Structure....');
        end
        
        % Check MRI folder
        filecheck2_mri_raw = fullfile(filecheck1_mri, prefix_raw);
        filecheck2_mri_fmri = fullfile(filecheck1_mri, prefix_fmri);
        
        if (exist(filecheck2_mri_fmri,'dir'))&&(exist(filecheck2_mri_raw,'dir')) == 7
            % Folder are in order
            % Proceed further
            disp('OK');
        else
            msgbox('Error in Folder Structure....');
        end
    else
        msgbox('Error in Folder Structure....');
    end
        
end

end