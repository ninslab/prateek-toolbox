function gosinglemrsmegprocessing(hObject, eventdata, h)

workingdir = get(h.browsedirectoryvalue, 'String');
getlabelval = get(h.labelvalue,'String');
checkmaskcreation = get(h.maskcreation,'Value');
checkmasknorm = get(h.masknorm,'Value');
checkresultstring = get(h.resultstring,'Value');
getmeganalysis = get(h.meganalysis,'Value');

if getmeganalysis == 1 && checkmaskcreation == 0 && checkmasknorm == 0 && checkresultstring == 0
    % Only MEG Analysis
    meganalysisprocedure(workingdir);
    
elseif getmeganalysis == 1 && checkmaskcreation == 1 && checkmasknorm == 0 && checkresultstring == 0
    % Only Create raw Mask
    meganalysisprocedure(workingdir);    
    rawmrsmaskproc(workingdir, getlabelval);
    
elseif getmeganalysis == 1 && checkmaskcreation == 1 && checkmasknorm == 1 && checkresultstring == 0
    % Create raw and normalied mask
    meganalysisprocedure(workingdir);
    normalizemaskproc(workingdir, getlabelval);
    
elseif getmeganalysis == 1 && checkmaskcreation == 1 && checkmasknorm == 1 && checkresultstring == 1
    % Create raw and normalized mask and also create a result folder
    % consisting of the normalized images
    meganalysisprocedure(workingdir);
    resultmrsproc(workingdir, getlabelval);
    
else
    fprintf('Check for Error........\n\n');
end



end