function batchmegmrsproc(getbrowsedirectory)

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

h.label = uicontrol(h.figure ,'Style','text',...
    'String','Label',...
    'Position',[20 370 130 20]);

h.labelvalue = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[160 370 200 20]);

h.proc = uicontrol(h.figure ,'Style','text',...
    'String','Analysis',...
    'Position',[20 340 130 20]);

h.maskcreation = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Raw Mask',...
    'Position',[160 340 200 20],'HandleVisibility','off');

h.masknorm = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Mask Normalization',...
    'Position',[160 310 200 20],'HandleVisibility','off');

h.resultstring = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Results Folders',...
    'Position',[160 280 200 20],'HandleVisibility','off');

h.gobutton = uicontrol(h.figure ,'Style','pushbutton',...
    'String','Start',...
    'Position',[148 200 80 20]);

set(h.gobutton, 'callback',{@gosinglemrsmegprocessing, h});


end