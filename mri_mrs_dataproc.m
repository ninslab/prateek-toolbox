function mri_mrs_dataproc(hObject, eventdata, h)

h = guidata(hObject);

[file, path] = uigetfile('*.nii');
filepath_mrimrs = fullfile(path, file);

setappdata(0, 'filepathmrimrs', filepath_mrimrs);

guidata(hObject,h)

end