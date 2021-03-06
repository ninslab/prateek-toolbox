function singlemegproc(getbrowsedirectory)

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
    'Position',[20 410 130 20]);

h.meganalysisheadmodel = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Headmodel Creation',...
    'Position',[160 410 200 20],'HandleVisibility','off');

h.meganalysiscoregistration = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Co-Registration',...
    'Position',[160 380 200 20],'HandleVisibility','off');

h.meganalysisforwardmodel = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Forward Model',...
    'Position',[160 350 200 20],'HandleVisibility','off');

h.meganalysisinvertsion = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Inversion Model',...
    'Position',[160 320 200 20],'HandleVisibility','off');

h.meganalysisresults = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Results',...
    'Position',[160 290 200 20],'HandleVisibility','off');

h.gobutton = uicontrol(h.figure ,'Style','pushbutton',...
    'String','Start',...
    'Position',[148 200 80 20]);

set(h.gobutton, 'callback',{@gosinglemegproc, h});


end