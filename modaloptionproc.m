function modaloptionproc(hObject, eventdata, h)

menu_val = get(h.modaloption,'Value');

switch menu_val
    case 1
        % Single Modal Analysis
        h.analysisoption = uicontrol(h.figure,'Style', 'popup', ...
            'Units',    'pixels', ...
            'Position', [148, 280, 250, 22], ...
            'String',   {'MRS (Mask) Analysis','fMRI Analysis', 'MEG Analysis', 'QSM Analysis'});
    case 2
        % Multi Modal Analysis
        h.analysisoption = uicontrol(h.figure,'Style', 'popup', ...
            'Units',    'pixels', ...
            'Position', [148, 280, 250, 22], ...
            'String',   {'fMRI - MRS Analysis','MEG - MRS Analysis','fMRI - QSM Analysis','MEG - fMRI Analysis '});
    otherwise
        % Do Nothing
end

guidata(hObject,h);

end