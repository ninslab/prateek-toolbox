function qsm_dataproc(hObject, eventdata, h)

h = guidata(hObject);

filepath_qsmdicom = uigetdir;
setappdata(0,'qsmdsinglefilepath', filepath_qsmdicom);

guidata(hObject,h)

end