function gomaskbuttonproc_meg_fmri(hObject, eventdata, h)

% get P Value from the GUI
% user defined
p_value = get(h.pvaluevnum, 'String');

% Initialize directory
initdir = cd; 
spmdirectory = fullfile(initdir,'spm12'); % SPM 12 directory
marsbardirectory = fullfile(initdir,'marsbar-0.44'); % Marsbar 0.44 directory

% Adding path
addpath(spmdirectory);
addpath(marsbardirectory);

% Initiate Marsbar 0.44
marsbar('on');

% Call operational function
marsbarfunctional_operation(hObject, eventdata, h, p_value);

%Overlap
initialDir = getappdata(0, 'dirmain');
overlay_fmri_meg(initialDir);

end