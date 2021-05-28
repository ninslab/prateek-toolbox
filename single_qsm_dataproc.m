function single_qsm_dataproc(hObject, eventdata, h)

h = guidata(hObject);

[file, path] = uigetfile('*.nii');
filepath_qsmsingle_mri = fullfile(path, file);

setappdata(0,'qsm_mrisingle', filepath_qsmsingle_mri);

guidata(hObject,h)


end