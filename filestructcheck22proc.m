function filestructcheck22proc(hObject, eventdata, h)

dir_value = get(h.browsedirupdate,'String'); disp(dir_value);
label_val = get(h.labelmrsval,'String'); disp(label_val);


prefix_main = 'Subjects';
prefix_mri = 'MRI';
prefix_mrs = 'MRS';
prefix_raw = 'Raw';
prefix_meg = 'MEG';

dir_updated = fullfile(dir_value,prefix_main);

% parse subjects
subjects = dir(dir_updated);
num = length(subjects);

for i = 3:num
    
    filename = subjects(i).name;
    filename_dir = fullfile(dir_updated,filename);
    filecheck1_mri = fullfile(filename_dir,prefix_mri);
    filecheck1_mrs = fullfile(filename_dir, prefix_mrs);
    filecheck1_meg = fullfile(filename_dir, prefix_meg);
    
    if (exist(filecheck1_mri,'dir')) && (exist(filecheck1_mrs,'dir')) && (exist(filecheck1_meg,'dir')) == 7
        % Folders are in order
        % Proceed further
        
        % Checking MRI folder struct
        filecheck2_mri_raw = fullfile(filecheck1_mri,prefix_raw);
        filecheck2_mri_mrs = fullfile(filecheck1_mri,prefix_mrs);
        filecheck2_mri_meg = fullfile(filecheck1_mri, prefix_meg);
        
        if (exist(filecheck2_mri_raw,'dir'))&&(exist(filecheck2_mri_mrs,'dir')) && (exist(filecheck2_mri_meg,'dir')) == 7
            % Folder are in order
            % Proceed further
            disp('OK');
        else
            msgbox('Error in Folder Structure....');
        end
        
        % Checking MRS folder struct
        filecheck2_mrs_raw = fullfile(filecheck1_mrs,prefix_raw);
        filecheck2_mrs_label = fullfile(filecheck1_mrs,label_val);
        
        if(exist(filecheck2_mrs_raw,'dir'))&&(exist(filecheck2_mrs_label,'dir')) == 7
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