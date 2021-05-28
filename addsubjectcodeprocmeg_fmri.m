function addsubjectcodeprocmeg_fmri(hObject, eventdata, h)

dir_val = getappdata(0, 'dirmain');
dir_val_1 = strcat(dir_val, '/Subjects');
disp(dir_val_1);

subject_name = get(h.subjectcodeaddition, 'String');disp(subject_name);
subfolder_name = char(subject_name);

fmridatadir = getappdata(0, 'filepathfmri'); disp(fmridatadir);
fmrimridatadir = getappdata(0, 'filepathmrifmri'); disp(fmrimridatadir);
megfmridatadir = getappdata(0, 'filepathfmrimeg'); disp(megfmridatadir);
megmripathdir = getappdata(0, 'filepathmegmri'); disp(megmripathdir);

f = waitbar(0,'Creating Folders...');

file_dir = fullfile(dir_val_1, subfolder_name);
file_fMRI = strcat(file_dir, '/fMRI');
file_MRI = strcat(file_dir,'/MRI');
file_MEG = strcat(file_dir,'/MEG');

mkdir (file_dir);
mkdir (file_dir, 'MEG');

mkdir (file_dir, 'fMRI');
mkdir (file_fMRI, 'Raw');
mkdir (file_fMRI, 'EPI');
mkdir (file_fMRI, 'Analysis');

mkdir (file_dir,'MRI');
mkdir (file_MRI, 'Raw');
mkdir (file_MRI, 'fMRI');
mkdir (file_MRI, 'MEG')

waitbar(.33,f,'Creating Directory');
pause(1)

file0 = strcat(file_dir, '/MEG/');
file1 = strcat(file_dir, '/fMRI/');
file2 = strcat(file_fMRI, '/Raw/');
file3 =  strcat(file_fMRI, '/EPI/');
file4 = strcat(file_fMRI, '/Analysis/');

file5 = strcat(file_dir,'/MRI');
file6 = strcat(file_MRI, '/Raw');
file7 = strcat(file_MRI, '/fMRI');
file8 = strcat(file_MRI, '/MEG');

waitbar(.67,f,'Copying Data');
pause(1)

copyfile(fmridatadir, file2);
copyfile(fmridatadir, file3);
copyfile(fmrimridatadir, file6);
copyfile(fmrimridatadir , file7);
copyfile(megfmridatadir , file0);
copyfile(megmripathdir , file8);
copyfile(megmripathdir , file6);

waitbar(1,f,'Finishing');
pause(1)

close(f)

set(h.subjectcodeaddition, 'String' ,'');
f = msgbox('Operation Completed');

guidata(hObject,h)


end