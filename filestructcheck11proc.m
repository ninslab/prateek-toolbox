function filestructcheck11proc(hObject, eventdata, h)

dir_value = get(h.browsedirupdate,'String'); disp(dir_value);
label_val = get(h.labelmrsval,'String'); disp(label_val);


prefix_main = 'Subjects';
prefix_mri = 'MRI';
prefix_mrs = 'MRS';
prefix_raw = 'Raw';


dir_updated = fullfile(dir_value,prefix_main);

% parse subjects
subjects = dir(dir_updated);
num = length(subjects);

for i = 3:num
    
    filename = subjects(i).name;
    filename_dir = fullfile(dir_updated,filename);
    filecheck1_mri = fullfile(filename_dir,prefix_mri);
    filecheck1_mrs = fullfile(filename_dir, prefix_mrs);
    
    if (exist(filecheck1_mri,'dir')) && (exist(filecheck1_mrs,'dir')) == 7
        % Folders are in order
        % Proceed further
        filecheck2_mri_raw = fullfile(filecheck1_mri,prefix_raw);
        filecheck2_mri_mrs = fullfile(filecheck1_mri,prefix_mrs);
        
        % Checking MRI folder struct
        if (exist(filecheck2_mri_raw,'dir'))&&(exist(filecheck2_mri_mrs,'dir')) == 7
            % Folder are in order
            % Proceed further
            disp('OK');
        else
            msgbox('Error in Folder Structure....');
        end
        
        filecheck2_mrs_raw = fullfile(filecheck1_mrs,prefix_raw);
        filecheck2_mrs_label = fullfile(filecheck1_mrs,label_val);
        
        % Checking MRS folder struct
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