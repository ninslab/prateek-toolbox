function mri_fmri_qsm_dataproc(hObject, eventdata, h)

h = guidata(hObject);

[file, path] = uigetfile('*.nii');
filepath_mrifmri = fullfile(path, file);

setappdata(0, 'filepathmrifmri' , filepath_mrifmri);
guidata(hObject,h)

end