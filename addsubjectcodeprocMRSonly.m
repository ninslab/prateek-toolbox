function addsubjectcodeprocMRSonly(hObject, eventdata, h)

subjectfolderlabel = 'Subjects'; % prefix for subject folder

dir_val = getappdata(0, 'dirmain');
% dir_val_1 = strcat(dir_val, '/Subjects');
dir_val_1 = fullfile(dir_val, subjectfolderlabel); 
disp(dir_val_1);

subject_name = get(h.subjectcodeaddition, 'String');
disp(subject_name);
subfolder_name = char(subject_name);

mrimrsdatadir = getappdata(0, 'filepathmrimrs'); disp(mrimrsdatadir);
labelname = get(h.labelMRSvalue, 'String'); disp(labelname);
mrspathdir = getappdata(0, 'mrsfilepath'); disp(mrspathdir);
f = waitbar(0,'Creating Folders...');

file_dir = fullfile(dir_val_1, subfolder_name);
% file_fMRI = fullfilestrcat(file_dir, 'fMRI');
file_MRI = fullfile(file_dir,'MRI');
file_MRS = fullfile(file_dir,'MRS');

mkdir (file_dir);
% mkdir (file_dir, 'fMRI');
% mkdir (file_fMRI, 'Raw');
% mkdir (file_fMRI, 'EPI');
% mkdir (file_fMRI, 'Analysis');

mkdir (file_dir,'MRI');
mkdir (file_MRI, 'Raw');
% mkdir (file_MRI, 'fMRI');
mkdir (file_MRI, 'MRS');

mkdir (file_dir,'MRS');
mkdir (file_MRS, 'Raw');
mkdir (file_MRS, labelname);
% mkdir (file_MRS, 'LPC');

% Copying files to folders respectively

waitbar(.33,f,'Creating Directory');
pause(1)

% file1 = fullfile(file_dir, 'fMRI');
% file2 = fullfile(file_fMRI, 'Raw');
% file3 =  fullfile(file_fMRI, 'EPI');
% file4 = fullfile(file_fMRI, 'Analysis');

file5 = fullfile(file_dir,'MRI');
file6 = fullfile(file_MRI, 'Raw');
% file7 = fullfile(file_MRI, 'fMRI');
file8 = fullfile(file_MRI, 'MRS');

file9 = fullfile(file_dir,'MRS');
file10 = fullfile(file_MRS, 'Raw');
file11 = fullfile(file_MRS, labelname);
%file12 = strcat(file_MRS, '/LPC');

waitbar(.67,f,'Copying Data');
pause(1)

%copyfile(fmridatadir, file2);
%copyfile(fmridatadir, file3);
%copyfile(fmrimridatadir, file6);
%copyfile(fmrimridatadir , file7);
copyfile(mrimrsdatadir , file6);
copyfile(mrimrsdatadir , file8);
copyfile(mrspathdir, file10);
copyfile(mrspathdir, file11);

waitbar(1,f,'Finishing');
pause(1)

close(f)

set(h.subjectcodeaddition, 'String' ,'');
f = msgbox('Operation Completed');

guidata(hObject,h)

end