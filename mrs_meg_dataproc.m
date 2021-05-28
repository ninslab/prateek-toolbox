function mrs_meg_dataproc(hObject, eventdata, h)


h = guidata(hObject);

[file, path] = uigetfile('*.SPAR');
filepath_mrsdata = fullfile(path, file);

setappdata(0, 'filepathmrsdata' , filepath_mrsdata);
guidata(hObject,h)


end