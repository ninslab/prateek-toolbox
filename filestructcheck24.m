function filestructcheck24(dir_value)

prefix_main = 'Subjects';
prefix_mri = 'MRI';
prefix_fMRI = 'fMRI';
prefix_meg = 'MEG';
prefix_raw = 'Raw';
prefix_epi = 'EPI';
prefix_analysis = 'Analysis';

dir_updated = fullfile(dir_value,prefix_main);

% parse subjects
subjects = dir(dir_updated);
num = length(subjects);

for i = 3:num
    
    filename = subjects(i).name;
    filename_dir = fullfile(dir_updated,filename);
    filecheck1_mri = fullfile(filename_dir,prefix_mri);
    filecheck1_fMRI = fullfile(filename_dir, prefix_fMRI);
    filecheck1_meg = fullfile(filename_dir, prefix_meg);
    
    if (exist(filecheck1_mri,'dir')) && (exist(filecheck1_fMRI,'dir')) && (exist(filecheck1_meg,'dir')) == 7
        % Folders are in order
        % Proceed further
        
        % Checking MRI folder struct
        filecheck2_mri_raw = fullfile(filecheck1_mri,prefix_raw);
        filecheck2_mri_fmri = fullfile(filecheck1_mri,prefix_fMRI);
        filecheck2_mri_meg = fullfile(filecheck1_mri, prefix_meg);
        
        if (exist(filecheck2_mri_raw,'dir'))&&(exist(filecheck2_mri_fmri,'dir')) && (exist(filecheck2_mri_meg,'dir')) == 7
            % Folder are in order
            % Proceed further
            disp('OK');
        else
            msgbox('Error in Folder Structure....');
        end
        
        % Checking fMRI folder struct
        filecheck2_fMRI_raw = fullfile(filecheck1_fMRI,prefix_raw);
        filecheck2_fMRI_epi = fullfile(filecheck1_fMRI,prefix_epi);
        filecheck2_fMRI_analysis = fullfile(filecheck1_fMRI,prefix_analysis);
        
        if(exist(filecheck2_fMRI_raw,'dir'))&&(exist(filecheck2_fMRI_epi,'dir')) && (exist(filecheck2_fMRI_analysis,'dir'))== 7
            % Folder are in order
            % Proceed further
            disp('OK');
        else
            msgbox('Error in Folder Structure....');
        end
        
    else
        msgbox('Error in Folder structure....');
    end
    
end

end