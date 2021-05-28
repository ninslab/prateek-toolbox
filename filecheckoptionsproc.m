function filecheckoptionsproc(hObject, eventdata, h)

h = guidata(hObject);

a = cd;
modaloptionvalue = get(h.modaloption,'Value');
analysisoptionvalue= get(h.analysisoption,'Value');

filecheck_inp = get(h.filecheckoptions, 'Value');

switch(filecheck_inp)
    case 1
        % Check file structure
        dir_value = get(h.browsedirupdate,'String');
        
        if modaloptionvalue == 1 && analysisoptionvalue == 1
            % Single Modal && MRS Mask Analysis
            filestructcheck11(hObject, eventdata,h);
            
        elseif modaloptionvalue == 1 && analysisoptionvalue == 2
            % Single Modal && fMRI Analysis
            filestructcheck12(dir_value);
            
        elseif modaloptionvalue == 1 && analysisoptionvalue == 3
            % Single Modal && MEG Analysis
            filestructcheck13(dir_value);
            
        elseif modaloptionvalue == 1 && analysisoptionvalue == 4
            % Single Modal && QSM Analysis
            filestructcheck14(dir_value);
            
        elseif modaloptionvalue == 2 && analysisoptionvalue == 1
            % Multi Modal && fMRI-MRS Analysis
            filestructcheck21(hObject, eventdata, h);
            
        elseif modaloptionvalue == 2 && analysisoptionvalue == 2
            % Multi Modal && MEG-MRS Analysis
            filestructcheck22(hObject, eventdata, h);
            
        elseif modaloptionvalue == 2 && analysisoptionvalue == 3
            % Multi Modal && fMRI-QSM Analysis
            filestructcheck23(dir_value);
            
        elseif modaloptionvalue == 2 && analysisoptionvalue == 4
            % Multi Modal && MEG-fMRI Analysis
            filestructcheck24(dir_value);
            
        else
            % Do Nothing
        end
        
    case 2
        % Generate file structure
        dir_value = get(h.browsedirupdate,'String');
        
        if modaloptionvalue == 1 && analysisoptionvalue == 1
            % Single Modal && MRS Mask Analysis
            filestructgenerate11(dir_value);
            
        elseif modaloptionvalue == 1 && analysisoptionvalue == 2
            % Single Modal && fMRI Analysis
            filestructgenerate12(dir_value);
            
        elseif modaloptionvalue == 1 && analysisoptionvalue == 3
            % Single Modal && MEG Analysis
            filestructgenerate13(dir_value);
            
        elseif modaloptionvalue == 1 && analysisoptionvalue == 4
            % Single Modal && QSM Analysis
            filestructgenerate14(dir_value);
            
        elseif modaloptionvalue == 2 && analysisoptionvalue == 1
            % Multi Modal && fMRI-MRS Analysis
            filestructgenerate21(dir_value);
            
        elseif modaloptionvalue == 2 && analysisoptionvalue == 2
            % Multi Modal && MEG-MRS Analysis
            filestructgenerate22(dir_value);
            
        elseif modaloptionvalue == 2 && analysisoptionvalue == 3
            % Multi Modal && fMRI-QSM Analysis
            filestructgenerate23(dir_value);
            
        elseif modaloptionvalue == 2 && analysisoptionvalue == 4
            % Multi Modal && MEG-fMRI Analysis
            filestructgenerate24(dir_value);
            
        else
            % Do Nothing
        end
        
end

guidata(hObject,h)

end
