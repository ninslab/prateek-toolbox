function filestructcheck21proc(hObject, eventdata, h)

dir_value = get(h.browsedirupdate,'String'); disp(dir_value);
label_val = get(h.labelmrsval,'String'); disp(label_val);


prefix_main = 'Subjects';
prefix_mri = 'MRI';
prefix_mrs = 'MRS';
prefix_raw = 'Raw';
prefix_fmri = 'fMRI';
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
    filecheck1_mrs = fullfile(filename_dir, prefix_mrs);
    filecheck1_fmri = fullfile(filename_dir, prefix_fmri);
    
    if (exist(filecheck1_mri,'dir')) && (exist(filecheck1_mrs,'dir')) && (exist(filecheck1_fmri,'dir')) == 7
        % Folders are in order
        % Proceed further
      
        % Checking MRI folder struct
        filecheck2_mri_raw = fullfile(filecheck1_mri,prefix_raw);
        filecheck2_mri_mrs = fullfile(filecheck1_mri,prefix_mrs);
        filecheck2_mri_fmri = fullfile(filecheck1_mri, prefix_fmri);
        
        if (exist(filecheck2_mri_raw,'dir'))&&(exist(filecheck2_mri_mrs,'dir')) && (exist(filecheck2_mri_fmri,'dir')) == 7
            % Folder are in order
            % Proceed further
            disp('OK');
        else
            msgbox('Error in Folder Structure....');
        end
        
        % Checking MRS folder struct
        filecheck2_mrs_raw = fullfile(filecheck1_mrs,prefix_raw);
        filecheck2_mrs_label = fullfile(filecheck1_mrs,label_val);
        
        if (exist(filecheck2_mrs_raw,'dir'))&&(exist(filecheck2_mrs_label,'dir')) == 7
            % Folder are in order
            % Proceed further
            disp('OK');
        else
            msgbox('Error in Folder Structure....');
        end
        
        % Checking fMRI folder struct
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
    else
        msgbox('Error in Folder structure....');
    end
    
end

end