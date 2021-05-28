% Structure MarsBar operational functions for Prateek V.2.0
%
% Author:-
%
% Saurav Roy,
% Research and Development Engineer,
% Neuroimaging and Neurospectroscopy Lab,
% National Brain Research Centre,
% Manesar, India

function marsbar_GUI_meg_fmri(hObject, eventdata, h)

h.figure1 = figure('position' , [500 440 400 500]);
set(h.figure1, 'Color', [0.43 0.76 0.70]);
h.axes = axes('Units', 'Pixels', 'Position' , [75 370 250 120]);

s = imread('prateek_1.png');
imshow(s);

h.atlasselection = uicontrol(h.figure1 ,'Style','pushbutton',...
    'String','Select Atlas.',...
    'Position',[20 320 130 20]);

h.atlasname= uicontrol(h.figure1,'Style', 'text', ...
    'Units', 'pixels', ...
    'Position', [160, 320, 220, 20], ...
    'String', '');

h.pvaluelabel = uicontrol(h.figure1,'Style', 'text', ...
    'Units', 'pixels', ...
    'Position', [20, 280, 130, 18], ...
    'String',  'p Value');

h.pvaluevnum = uicontrol(h.figure1,'Style', 'edit', ...
    'Units', 'pixels', ...
    'Position', [160, 280, 220, 20]);

h.gomaskbutton = uicontrol(h.figure1 ,'Style','pushbutton',...
    'String','Proceed with Mask Creation',...
    'Position',[20 230 360 25]);

set(h.atlasselection, 'callback', {@atlasselectionproc ,h});
set(h.gomaskbutton, 'callback', {@gomaskbuttonproc_meg_fmri, h});

end