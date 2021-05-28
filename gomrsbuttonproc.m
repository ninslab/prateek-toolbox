function gomrsbuttonproc(hObject, eventdata, h)

workingdir = get(h.browsedirectoryvalue, 'String');
getlabelval = get(h.labelvalue,'String');
checkmaskcreation = get(h.maskcreation,'Value');
checkmasknorm = get(h.masknorm,'Value');
checkresultstring = get(h.resultstring,'Value');


if checkmaskcreation == 1 && checkmasknorm == 0 && checkresultstring == 0
    % Only Create raw Mask
    rawmrsmaskproc(workingdir, getlabelval);
elseif checkmaskcreation == 1 && checkmasknorm == 1 && checkresultstring == 0
    % Create raw and normalied mask
    normalizemaskproc(workingdir, getlabelval);
elseif checkmaskcreation == 1 && checkmasknorm == 1 && checkresultstring == 1
    % Create raw and normalized mask and also create a result folder
    % consisting of the normalized images
    resultmrsproc(workingdir, getlabelval);
else
    fprintf('Check for Error........\n\n');
end

end