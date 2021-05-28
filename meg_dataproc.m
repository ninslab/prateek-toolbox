function meg_dataproc(hObject, eventdata, h)

h = guidata(hObject);

[file, path] = uigetfile('*.fif');
filepath_meg = fullfile(path, file);
setappdata(0,'filepathfmrimeg', filepath_meg);

guidata(hObject,h)

end