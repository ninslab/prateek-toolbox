function main

h.figure = figure('position' , [500 440 400 500],'name','PRATEEK', 'NumberTitle','off');

set(h.figure, 'Color', [0.43 0.76 0.70]);

% Extra functions
addpath('Registration_Extra_functions');

% Add SPM12 to matlab path
rmpath('spm12'); % remove existing SPM12 path
spm12path_current = fullfile(pwd,'spm12');
addpath(spm12path_current);

% Check if dcm2niix is added or not
path_bash = fullfile(pwd,'BashScripts','dcm_check.sh');
system(path_bash);

% Start with GUI code

h.axes = axes('Units', 'Pixels', 'Position' , [75 370 250 120]);

s = imread('prateek_1.png');
imshow(s);

h.textmodal = uicontrol(h.figure ,'Style','text',...
    'String','Select Modality.',...
    'Position',[5 320 130 20]);

h.modaloption = uicontrol(h.figure,'Style', 'popup', ...
    'Units',    'pixels', ...
    'Position', [148, 320, 250, 22], ...
    'String',   {'Single Modal Processing',' Multi Modal Processing'});

h.textmodalitytype = uicontrol(h.figure ,'Style','text',...
    'String','Select Analysis',...
    'Position',[5 280 130 20]);

h.analysisoptiondefault = uicontrol(h.figure,'Style', 'popup', ...
    'Units',    'pixels', ...
    'Position', [148, 280, 250, 22], ...
    'String',   {'','','',''});

h.processingtype = uicontrol(h.figure ,'Style','text',...
    'String','Select Processing Type',...
    'Position',[5 240 130 20]);

h.processingtypeoptions = uicontrol(h.figure,'Style', 'popup', ...
    'Units',    'pixels', ...
    'Position', [148, 240, 250, 22], ...
    'String',   {'Single','Batch'});

h.browsetype = uicontrol(h.figure ,'Style','text',...
    'String','Browse Directory',...
    'Position',[5 200 130 20]);

h.browse = uicontrol(h.figure ,'Style','pushbutton',...
    'String','Browse',...
    'Position',[148 200 50 20]);
h.browsedirupdate = uicontrol(h.figure, 'Style', 'edit',...
    'String', '',...
    'Position',[200 200 195 20 ]);

set(h.browse, 'callback', {@browseproc, h});

h.filecheck = uicontrol(h.figure ,'Style','text',...
    'String','File Check',...
    'Position',[5 160 130 20]);

h.filecheckoptions = uicontrol(h.figure,'Style', 'popup', ...
    'Units',    'pixels', ...
    'Position', [148, 160, 250, 22], ...
    'String',   {'Check File Structure','Generate File Structure'});

h.gobuttonfmrianalysis  = uicontrol(h.figure ,'Style','pushbutton',...
    'String','Image Analysis & Mask Creation',...
    'Position',[50 100 300 25]);

h.gomarsbaranalysis  = uicontrol(h.figure ,'Style','pushbutton',...
    'String','Mask Overlay',...
    'Position',[50 60 300 25]);


set(h.modaloption, 'callback', {@modaloptionproc,h});
set(h.filecheckoptions, 'callback', {@filecheckoptionsproc, h} );
set(h.gobuttonfmrianalysis, 'callback', {@gobuttonproc, h});
set(h.gomarsbaranalysis, 'callback', {@masksaveproc, h});
% set(h.gomarsbaranalysis, 'callback', {@marsbar_GUI, h});

end