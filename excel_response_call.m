function excel_response_call(hObject, eventdata, h)

h = guidata(hObject);

[file, path] = uigetfile('*.xlsx');
filepath_fmri_response = fullfile(path, file);
setappdata(0,'excel_fmri_response_sheet', filepath_fmri_response);

guidata(hObject,h)

end