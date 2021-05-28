function masksaveproc(hObject, eventdata, h)

h = guidata(hObject);

% Identify modality selected
modaloptionvalue = get(h.modaloption,'Value');
analysisoptionvalue= get(h.analysisoption,'Value');
dir_value = get(h.browsedirupdate,'String');

% case conditions
if modaloptionvalue == 1 && analysisoptionvalue == 1 % Single Modal && MRS Mask Analysis
    % saveproc11(dir_value);
    msgbox('Only single modality available; Need second modality for overlay');
    
elseif modaloptionvalue == 1 && analysisoptionvalue == 2 % Single Modal && fMRI Analysis
    % saveproc12(dir_value);
    msgbox('Only single modality available; Need second modality for overlay');
    
elseif modaloptionvalue == 1 && analysisoptionvalue == 3 % Single Modal && MEG Analysis
    % saveproc13(dir_value);
    msgbox('Only single modality available; Need second modality for overlay');
    
elseif modaloptionvalue == 1 && analysisoptionvalue == 4 % Single Modal && QSM Analysis
    % saveproc14(dir_value);
    msgbox('Only single modality available; Need second modality for overlay');
    
elseif modaloptionvalue == 2 && analysisoptionvalue == 1 % Multi Modal && fMRI-MRS Analysis
    saveproc21(hObject, eventdata, h);
    
elseif modaloptionvalue == 2 && analysisoptionvalue == 2 % Multi Modal && MEG-MRS Analysis
    saveproc22(dir_value);
    
elseif modaloptionvalue == 2 && analysisoptionvalue == 3 % Multi Modal && fMRI-QSM Analysis
    saveproc23(hObject, eventdata, h);
    
elseif modaloptionvalue == 2 && analysisoptionvalue == 4 % Multi Modal && MEG-fMRI Analysis
    saveproc24(hObject, eventdata, h);
    
else
    % Do Nothing
end

guidata(hObject,h);

end