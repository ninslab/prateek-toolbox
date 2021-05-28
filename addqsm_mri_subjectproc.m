function addqsm_mri_subjectproc(hObject, eventdata, h)

subjectfolderlabel = 'Subjects'; % prefix for subject folder

dir_val = getappdata(0, 'dirmain');
% dir_val_1 = strcat(dir_val, '/Subjects');
dir_val_1 = fullfile(dir_val, subjectfolderlabel); 
disp(dir_val_1);

subject_name = get(h.subjectcodeaddition, 'String');
disp(subject_name);
subfolder_name = char(subject_name);

% labelname = get(h.labelMRSvalue, 'String');
% disp(labelname);
% Directory definition of files

fmridatadir = getappdata(0,'filepathfmri'); disp(fmridatadir);
fmrimridatadir = getappdata(0, 'filepathmrifmri');disp(fmrimridatadir);
%mrimrsdatadir = getappdata(0, 'filepathmrimrs'); disp(mrimrsdatadir);
%mrspathdir = getappdata(0, 'mrsfilepath'); disp(mrspathdir);
dir_val_qsmdicom = getappdata(0, 'qsmdsinglefilepath');
dir_val_qsmmri = getappdata(0, 'qsm_mrisingle');
fmri_response_sheet = getappdata(0,'excel_fmri_response_sheet'); disp(fmri_response_sheet);

% File Generating Directory

f = waitbar(0,'Creating Folders...');

file_dir = fullfile(dir_val_1, subfolder_name);
file_fMRI = strcat(file_dir, '/fMRI');
file_MRI = strcat(file_dir,'/MRI');
%file_MRS = strcat(file_dir,'/MRS');
file_QSM = strcat(file_dir,'/QSM/DICOM');
file_dir_mri = strcat(file_dir, '/MRI','/QSM');


mkdir (file_dir);
mkdir (file_dir, 'fMRI');
mkdir (file_fMRI, 'Raw');
mkdir (file_fMRI, 'EPI');
mkdir (file_fMRI, 'Analysis');

mkdir (file_dir,'MRI');
mkdir (file_MRI, 'Raw');
mkdir (file_MRI, 'fMRI');
%mkdir (file_MRI, 'MRS');

% mkdir (file_dir,'MRS');
% mkdir (file_MRS, 'Raw');
% mkdir (file_MRS, labelname);
% mkdir (file_MRS, 'LPC');
mkdir(file_QSM);
mkdir(file_dir_mri);

% Copying files to folders respectively

waitbar(.33,f,'Creating Directory');
pause(1)

file1 = fullfile(file_dir, 'fMRI');
file2 = fullfile(file_fMRI, 'Raw');
file3 =  fullfile(file_fMRI, 'EPI');
file4 = fullfile(file_fMRI, 'Analysis');

file5 = fullfile(file_dir,'MRI');
file6 = fullfile(file_MRI, 'Raw');
file7 = fullfile(file_MRI, 'fMRI');
%file8 = fullfile(file_MRI, 'MRS');

%file9 = fullfile(file_dir,'MRS');
%file10 = fullfile(file_MRS, 'Raw');
%file11 = fullfile(file_MRS, labelname);
%file12 = strcat(file_MRS, '/LPC');

waitbar(.67,f,'Copying Data');
pause(1)

copyfile(fmri_response_sheet, file_dir);
copyfile(fmridatadir, file2);
copyfile(fmridatadir, file3);
copyfile(fmrimridatadir, file6);
copyfile(fmrimridatadir , file7);
% copyfile(mrimrsdatadir , file6);
% copyfile(mrimrsdatadir , file8);
% copyfile(mrspathdir, file10);
% copyfile(mrspathdir, file11);
copyfile(dir_val_qsmdicom, file_QSM);
copyfile(dir_val_qsmmri, file_dir_mri);
copyfile(dir_val_qsmmri, file6);

waitbar(1,f,'Finishing');
pause(1)

close(f)

set(h.subjectcodeaddition, 'String' ,'');
f = msgbox('Operation Completed');

guidata(hObject,h)

end