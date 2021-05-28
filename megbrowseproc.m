function megbrowseproc(hObject, eventdata, h)

h = guidata(hObject);

[file, path] = uigetfile('*.fif');
filepath_megbrowsesingle= fullfile(path, file);

setappdata(0,'meg_browsesingle', filepath_megbrowsesingle);

guidata(hObject,h)

end