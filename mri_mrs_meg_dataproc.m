function mri_mrs_meg_dataproc(hObject, eventdata, h)


h = guidata(hObject);

[file, path] = uigetfile('*.nii');
filepath_mrs_mri_data = fullfile(path, file);

setappdata(0, 'filepathmeg_mrs_mridata' , filepath_mrs_mri_data);
guidata(hObject,h)


end