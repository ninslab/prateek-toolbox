function browseproc(hObject, eventdata, h)

    dirpath = uigetdir();
    set(h.browsedirupdate, 'string', dirpath);
    setappdata(0, 'dirmain', dirpath);
   
end