function filestructcheck21(hObject, eventdata, h)

h.figure = figure('position' , [600 440 400 100]);
set(h.figure, 'Color', [0.43 0.76 0.70]);

h.numberofsubjects = uicontrol(h.figure ,'Style','text',...
    'String','Label (MRS Mask)',...
    'Position',[20 50 150 20]);

h.labelmrsval = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[200 50 180 20]);

h.addsubjectcode = uicontrol(h.figure ,'Style','pushbutton',...
    'String','Check',...
    'Position',[20 20 360 20]);

set(h.addsubjectcode,'callback', {@filestructcheck21proc,h});

end