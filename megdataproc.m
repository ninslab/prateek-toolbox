function megdataproc(hObject, eventdata, h)

h = guidata(hObject);

[file, path] = uigetfile('*.fif');
filepath_megdata = fullfile(path, file);

setappdata(0, 'filepathmegdata' , filepath_megdata);
guidata(hObject,h)

end