function single_meg_dataproc(hObject, eventdata, h)

h = guidata(hObject);

[file, path] = uigetfile('*.nii');
filepath_meg_mrisingle= fullfile(path, file);

setappdata(0,'meg_mri_browsesingle', filepath_meg_mrisingle);

guidata(hObject,h)

end