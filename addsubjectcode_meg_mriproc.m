function addsubjectcode_meg_mriproc(hObject, eventdata, h)

key1 = 'MEG';
key2 = 'MRI';
key3 = 'Raw';
key4 = 'MRS';

megdatafile = getappdata(0,'filepathmegdata');
meg_mri_filedata = getappdata(0, 'filepathmrimeg');
mrs_meg_filedata = getappdata(0, 'filepathmrsdata');
mrs_meg_mri_data = getappdata(0, 'filepathmeg_mrs_mridata');
labelname = get(h.numberofsubjectsvalue, 'String');

dir_val = getappdata(0, 'dirmain');
dir_val_1 = fullfile(dir_val, 'Subjects');

subject_name = get(h.subjectcodeaddition, 'String');disp(subject_name);
subfolder_name = char(subject_name);

f = waitbar(0,'Creating Folders...');

file_dir = fullfile(dir_val_1, subfolder_name);
file_megdata = fullfile(file_dir, key1);
file_meg_mri_data = fullfile(file_dir, key2, key1);
file_meg_mri_dataraw = fullfile(file_dir, key2, key3);
file_mrsdata = fullfile(file_dir, key4, key3);
file_mrsmridata = fullfile(file_dir, key2, key4);
file_mrslabel = fullfile(file_dir, key4, labelname);

waitbar(.33, f, 'Creating Directory');
pause(1)

mkdir(file_megdata);
mkdir(file_meg_mri_data);
mkdir(file_mrsdata);
mkdir(file_mrsmridata );
mkdir(file_mrslabel);
mkdir(file_meg_mri_dataraw);

copyfile(megdatafile, file_megdata);
copyfile(meg_mri_filedata, file_meg_mri_data);
copyfile(meg_mri_filedata, file_meg_mri_dataraw);

waitbar(.66, f, 'Creating Directory');
pause(1)

copyfile(mrs_meg_filedata, file_mrsdata);
copyfile(mrs_meg_filedata, file_mrslabel);
copyfile(mrs_meg_mri_data, file_mrsmridata);
copyfile(mrs_meg_mri_data, file_meg_mri_dataraw);

waitbar(1,f,'Finishing');
pause(1)

close(f)
set(h.subjectcodeaddition, 'String' ,'');

f = msgbox('Operation Completed');

guidata(hObject,h)

end