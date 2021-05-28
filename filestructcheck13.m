function filestructcheck13(dir_value)

prefix_main = 'Subjects';
prefix_mri = 'MRI';
prefix_meg = 'MEG';
prefix_raw = 'Raw';

dir_updated = fullfile(dir_value,prefix_main);

% parse subjects
subjects = dir(dir_updated);
num = length(subjects);

for i = 3:num
    
    filename = subjects(i).name;
    filename_dir = fullfile(dir_updated,filename);
    filecheck1_mri = fullfile(filename_dir,prefix_mri);
    filecheck1_meg = fullfile(filename_dir, prefix_meg);
    
    if(exist(filecheck1_meg,'dir'))&& (exist(filecheck1_mri,'dir')) == 7
        % Folder are in order
        % Proceed further
        %-------------------------------------------------------
        % NOTE: No MEG sub-folder, hence no check has been added
        %-------------------------------------------------------
        % Check MRI folder
        
        filecheck2_mri_raw = fullfile(filecheck1_mri,prefix_raw);
        filecheck2_mri_meg = fullfile(filecheck1_mri,prefix_meg);
        
        if (exist(filecheck2_mri_raw,'dir'))&&(exist(filecheck2_mri_meg,'dir')) == 7
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