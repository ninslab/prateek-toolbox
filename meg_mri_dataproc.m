function meg_mri_dataproc(hObject, eventdata, h)

h = guidata(hObject);

[file, path] = uigetfile('*.nii');
filepath_meg_mri= fullfile(path, file);
setappdata(0,'filepathmegmri', filepath_meg_mri);

guidata(hObject,h)

end