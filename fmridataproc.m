function fmridataproc(hObject, eventdata, h)


h = guidata(hObject);

[file, path] = uigetfile('*.nii');
filepath_fmri = fullfile(path, file);
setappdata(0,'filepathfmri', filepath_fmri);

guidata(hObject,h)

end