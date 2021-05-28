function batchfmrimrsproc(getbrowsedirectory)

h.figure = figure('position' , [500 440 400 500],'name','PRATEEK', 'NumberTitle','off');
set(h.figure, 'Color', [0.43 0.76 0.70]);

h.browsedirectory = uicontrol(h.figure ,'Style','text',...
    'String','Working Directory',...
    'Position',[20 450 130 20]);

h.browsedirectoryvalue = uicontrol(h.figure ,'Style','edit',...
    'String','test',...
    'Position',[160 450 200 20]);

set(h.browsedirectoryvalue,'String', getbrowsedirectory);

h.tr = uicontrol(h.figure ,'Style','text',...
    'String','TR(s)',...
    'Position',[20 410 130 20]);

h.trvalue = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[160 410 200 20]);

h.slice = uicontrol(h.figure ,'Style','text',...
    'String','Slice Number',...
    'Position',[20 370 130 20]);

h.slicenumber = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[160 370 200 20]);

h.proc = uicontrol(h.figure ,'Style','text',...
    'String','Analysis',...
    'Position',[20 330 130 20]);

h.procpreprocessing = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Preprocessing',...
    'Position',[160 330 200 20],'HandleVisibility','off');

h.subjectlevelanalysis = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Subject Level Analysis',...
    'Position',[160 300 200 20],'HandleVisibility','off');

% h.grouplevelanalysis = uicontrol(h.figure ,'Style','checkbox',...
%     'String','    Group Level Analysis',...
%     'Position',[160 270 200 20],'HandleVisibility','off');

h.labelstring = uicontrol(h.figure ,'Style','text',...
    'String','Label',...
    'Position',[20 240 130 20]);

h.labelvalue = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[160 240 200 20]);

h.mrsmasking = uicontrol(h.figure ,'Style','text',...
    'String','Mask',...
    'Position',[20 210 130 20]);

h.rawmaskstatus = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Raw Mask',...
    'Position',[160 210 200 20],'HandleVisibility','off');

h.normmaskstatus = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Normalized Mask',...
    'Position',[160 180 200 20],'HandleVisibility','off');

h.resultmaskstatus = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Results ',...
    'Position',[160 150 200 20],'HandleVisibility','off');

h.gobutton = uicontrol(h.figure ,'Style','pushbutton',...
    'String','Start',...
    'Position',[148 100 80 20]);

set(h.gobutton, 'callback',{@gobuttonfmrimrsproc, h});

end