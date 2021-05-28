function mrs_dataproc(hObject, eventdata, h)

h = guidata(hObject);

[file, path] = uigetfile('*.SPAR');
filepath_mrs = fullfile(path, file);

setappdata(0,'mrsfilepath', filepath_mrs);

guidata(hObject,h)


end