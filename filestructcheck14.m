function filestructcheck14(dir_value)

prefix_main = 'Subjects';
prefix_mri = 'MRI';
prefix_qsm = 'QSM';
prefix_raw = 'Raw';
prefix_dicom = 'DICOM';

dir_updated = fullfile(dir_value,prefix_main);

% parse subjects
subjects = dir(dir_updated);
num = length(subjects);

for i = 3:num
    
    filename = subjects(i).name;
    filename_dir = fullfile(dir_updated,filename);
    filecheck1_mri = fullfile(filename_dir,prefix_mri);
    filecheck1_qsm = fullfile(filename_dir, prefix_qsm);
    
    if (exist(filecheck1_qsm,'dir'))&&(exist(filecheck1_mri,'dir')) == 7
        % Folder are in order
        % Proceed further
        
        % Check QSM folder
        filecheck2_qsm_dicom = fullfile(filecheck1_qsm,prefix_dicom);
        
        if exist(filecheck2_qsm_dicom,'dir') == 7
            % Folder are in order
            % Proceed further
            disp('OK');
        else
            msgbox('Error in Folder Structure....');
        end
        
        % Check MRI folder
        filecheck2_mri_raw = fullfile(filecheck1_mri,prefix_raw);
        filecheck2_mri_qsm = fullfile(filecheck1_mri,prefix_qsm);
        
        if(exist(filecheck2_mri_qsm,'dir'))&&(exist(filecheck2_mri_raw,'dir')) == 7
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