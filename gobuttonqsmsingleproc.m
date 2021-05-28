function gobuttonqsmsingleproc(hObject, eventdata, h)

workingdir = get(h.browsedirectoryvalue, 'String');
checkb0val = get(h.b0value,'Value');
getnumcharvaluevalue = get(h.numcharvaluevalue, 'Value');
getfolderprefixvalue = get(h.folderprefixvalue, 'String');
getechoprefixvalue = get(h.echoprefixvalue, 'String');

checkreaddicom = get(h.readdicom, 'Value');
checkphaseunwrapping = get(h.phaseunwrapping, 'Value');
checkvsharp = get(h.vsharp, 'Value');
% checkstarqsm = get(h.starqsm, 'Value');
checkilsqrqsm = get(h.ilsqrqsm, 'Value');


if checkreaddicom == 1 && checkphaseunwrapping == 0 && checkvsharp == 0 && checkilsqrqsm == 0
    % Only read DICOM Images
    readdicomproc(workingdir, checkb0val, getnumcharvaluevalue, getfolderprefixvalue, getechoprefixvalue);
elseif checkreaddicom == 1 && checkphaseunwrapping == 1 && checkvsharp == 0 && checkilsqrqsm == 0
    % Dicom Read + Unwrapping   
    readdicomunwrapping(workingdir,checkb0val, getnumcharvaluevalue, getfolderprefixvalue, getechoprefixvalue);
elseif checkreaddicom == 1 && checkphaseunwrapping == 1 && checkvsharp == 1 && checkilsqrqsm == 0
    % Dicom Read + Unwrapping + V-SHARP
    readdicomunwrappingvsharp(workingdir,checkb0val, getnumcharvaluevalue, getfolderprefixvalue, getechoprefixvalue);
elseif checkreaddicom == 1 && checkphaseunwrapping == 1 && checkvsharp == 1 && checkilsqrqsm == 1
    % Dicom Read + Unwrapping + V-SHARP + iLSQR
    readdicomunwrappingvsharpilsqr(workingdir,checkb0val, getnumcharvaluevalue, getfolderprefixvalue, getechoprefixvalue);
    results_file_folder_qsm(workingdir);
else
    % Do Nothing
end


end