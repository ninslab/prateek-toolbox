function addsubjectqsmsingle(hObject, eventdata, h)

dir_val_qsmdicom = getappdata(0, 'qsmdsinglefilepath');
dir_val_qsmmri = getappdata(0, 'qsm_mrisingle');
dir_val = getappdata(0, 'dirmain');
dir_val_1 = strcat(dir_val, '/Subjects');

subject_name = get(h.subjectcodeaddition, 'String');disp(subject_name);
subfolder_name = char(subject_name);

f = waitbar(0,'Creating Folders...');

file_dir = fullfile(dir_val_1, subfolder_name);
file_QSM = strcat(file_dir,'/QSM/DICOM');
file_dir_mri = strcat(file_dir, '/MRI','/QSM');
file_dir_mri_raw = strcat(file_dir, '/MRI', '/Raw');

mkdir(file_QSM);
mkdir(file_dir_mri);
mkdir(file_dir_mri_raw);

waitbar(.33, f, 'Creating Directory');
pause(1)

copyfile(dir_val_qsmdicom, file_QSM);

waitbar(.33, f, 'Creating Directory');
pause(1)

copyfile(dir_val_qsmmri, file_dir_mri);
copyfile(dir_val_qsmmri, file_dir_mri_raw);

waitbar(1,f,'Finishing');
pause(1)

close(f)
set(h.subjectcodeaddition, 'String' ,'');

f = msgbox('Operation Completed');

guidata(hObject,h)

end