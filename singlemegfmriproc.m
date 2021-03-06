function singlemegfmriproc(getbrowsedirectory)

h.figure = figure('position' , [500 440 400 500],'name','PRATEEK', 'NumberTitle','off');
set(h.figure, 'Color', [0.43 0.76 0.70]);

h.browsedirectory = uicontrol(h.figure ,'Style','text',...
    'String','Working Directory',...
    'Position',[20 450 130 20]);

h.browsedirectoryvalue = uicontrol(h.figure ,'Style','edit',...
    'String','test',...
    'Position',[160 450 200 20]);

set(h.browsedirectoryvalue,'String', getbrowsedirectory);

h.analysis = uicontrol(h.figure ,'Style','text',...
    'String','Analysis',...
    'Position',[20 420 130 20]);

h.meganalysis = uicontrol(h.figure ,'Style','checkbox',...
    'String','    MEG Analysis',...
    'Position',[160 420 200 20],'HandleVisibility','off');

h.tr = uicontrol(h.figure ,'Style','text',...
    'String','TR(s)',...
    'Position',[20 370 130 20]);

h.trvalue = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[160 370 200 20]);

h.slice = uicontrol(h.figure ,'Style','text',...
    'String','Slice Number',...
    'Position',[20 340 130 20]);

h.slicenumber = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[160 340 200 20]);

h.proc = uicontrol(h.figure ,'Style','text',...
    'String','Analysis',...
    'Position',[20 310 130 20]);

h.procpreprocessing = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Preprocessing',...
    'Position',[160 310 200 20],'HandleVisibility','off');

h.subjectlevelanalysis = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Subject Level Analysis',...
    'Position',[160 280 200 20],'HandleVisibility','off');

h.gobutton = uicontrol(h.figure ,'Style','pushbutton',...
    'String','Start',...
    'Position',[148 200 80 20]);

set(h.gobutton, 'callback',{@gosinglemegfmriprocedure, h});


end