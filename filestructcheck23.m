function filestructcheck23(dir_value)

prefix_main = 'Subjects';
prefix_mri = 'MRI';
prefix_fMRI = 'fMRI';
prefix_qsm = 'QSM';
prefix_raw = 'Raw';
prefix_epi = 'EPI';
prefix_analysis = 'Analysis';
prefix_dicom = 'DICOM';

dir_updated = fullfile(dir_value,prefix_main);

% parse subjects
subjects = dir(dir_updated);
num = length(subjects);

for i = 3:num
    
    filename = subjects(i).name;
    filename_dir = fullfile(dir_updated,filename);
    filecheck1_mri = fullfile(filename_dir,prefix_mri);
    filecheck1_fMRI = fullfile(filename_dir, prefix_fMRI);
    filecheck1_qsm = fullfile(filename_dir, prefix_qsm);
    
    if (exist(filecheck1_mri,'dir')) && (exist(filecheck1_fMRI,'dir')) && (exist(filecheck1_qsm,'dir')) == 7
        % Folders are in order
        % Proceed further
        
        % Checking MRI folder struct
        filecheck2_mri_raw = fullfile(filecheck1_mri,prefix_raw);
        filecheck2_mri_fmri = fullfile(filecheck1_mri,prefix_fMRI);
        filecheck2_mri_qsm = fullfile(filecheck1_mri, prefix_qsm);
        
        if (exist(filecheck2_mri_raw,'dir'))&&(exist(filecheck2_mri_fmri,'dir')) && (exist(filecheck2_mri_qsm,'dir')) == 7
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
        
        % Checking QSM folder struct
        filecheck2_qsm_dicom = fullfile(filecheck1_qsm,prefix_dicom);
        
        if exist(filecheck2_qsm_dicom,'dir') == 7
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
