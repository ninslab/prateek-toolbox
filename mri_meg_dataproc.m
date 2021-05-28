function mri_meg_dataproc(hObject, eventdata, h)

h = guidata(hObject);

[file, path] = uigetfile('*.nii');
filepath_mrimeg = fullfile(path, file);

setappdata(0, 'filepathmrimeg' , filepath_mrimeg);
guidata(hObject,h)

end