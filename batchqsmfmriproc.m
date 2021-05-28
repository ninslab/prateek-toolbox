function batchqsmfmriproc(getbrowsedirectory)

h.figure = figure('position' , [500 440 400 600],'name','PRATEEK', 'NumberTitle','off');
set(h.figure, 'Color', [0.43 0.76 0.70]);

h.browsedirectory = uicontrol(h.figure ,'Style','text',...
    'String','Working Directory',...
    'Position',[20 550 130 20]);

h.browsedirectoryvalue = uicontrol(h.figure ,'Style','edit',...
    'String','test',...
    'Position',[160 550 200 20]);

set(h.browsedirectoryvalue,'String', getbrowsedirectory);

h.b0 = uicontrol(h.figure ,'Style','text',...
    'String','B0',...
    'Position',[20 510 130 20]);

h.b0value = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[160 510 200 20]);

h.numchar = uicontrol(h.figure ,'Style','text',...
    'String','ID Length',...
    'Position',[20 470 130 20]);

h.numcharvaluevalue = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[160 470 200 20]);

h.folderprefix= uicontrol(h.figure ,'Style','text',...
    'String','Folder Prefix',...
    'Position',[20 430 130 20]);

h.folderprefixvalue = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[160 430 200 20]);

h.echoprefix= uicontrol(h.figure ,'Style','text',...
    'String','Echo Prefix',...
    'Position',[20 390 130 20]);

h.echoprefixvalue = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[160 390 200 20]);

h.analysis = uicontrol(h.figure ,'Style','text',...
    'String','Analysis',...
    'Position',[20 350 130 20]);

h.readdicom = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Read DICOM',...
    'Position',[160 350 200 20],'HandleVisibility','off');

h.phaseunwrapping = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Phase Unwrapping',...
    'Position',[160 320 200 20],'HandleVisibility','off');

h.vsharp = uicontrol(h.figure ,'Style','checkbox',...
    'String','    V-SHARP',...
    'Position',[160 290 200 20],'HandleVisibility','off');

h.ilsqrqsm = uicontrol(h.figure ,'Style','checkbox',...
    'String','    iLSQR QSM',...
    'Position',[160 260 200 20],'HandleVisibility','off');

h.tr = uicontrol(h.figure ,'Style','text',...
    'String','TR(s)',...
    'Position',[20 220 130 20]);

h.trvalue = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[160 220 200 20]);

h.slice = uicontrol(h.figure ,'Style','text',...
    'String','Slice Number',...
    'Position',[20 190 130 20]);

h.slicenumber = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[160 190 200 20]);

h.proc = uicontrol(h.figure ,'Style','text',...
    'String','Analysis',...
    'Position',[20 160 130 20]);

h.procpreprocessing = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Preprocessing',...
    'Position',[160 160 200 20],'HandleVisibility','off');

h.subjectlevelanalysis = uicontrol(h.figure ,'Style','checkbox',...
    'String','    Subject Level Analysis',...
    'Position',[160 130 200 20],'HandleVisibility','off');

% h.grouplevelanalysis = uicontrol(h.figure ,'Style','checkbox',...
%     'String','    Group Level Analysis',...
%     'Position',[160 100 200 20],'HandleVisibility','off');

h.gobutton = uicontrol(h.figure ,'Style','pushbutton',...
    'String','Start',...
    'Position',[148 50 80 20]);

set(h.gobutton, 'callback',{@gobuttonbatchfmriqsmproc, h});

end