function gobuttonfmriqsmproc(hObject, eventdata, h)

% QSM Value Initialize

workingdir = get(h.browsedirectoryvalue, 'String');
checkb0val = get(h.b0value,'Value');
checkreaddicom = get(h.readdicom, 'Value');
checkphaseunwrapping = get(h.phaseunwrapping, 'Value');
checkvsharp = get(h.vsharp, 'Value');
checkilsqrqsm = get(h.ilsqrqsm, 'Value');

getnumcharvaluevalue = get(h.numcharvaluevalue, 'Value');
getfolderprefixvalue = get(h.folderprefixvalue, 'String');
getechoprefixvalue = get(h.echoprefixvalue, 'String');

% fMRI Value Initialize

checkpreprocessingval = get(h.procpreprocessing, 'Value');
checksubjectanalysisval = get(h.subjectlevelanalysis ,'Value');
tr_val = get(h.trvalue, 'String');
tr_value_num = str2double(tr_val);
slicenumbervalue = get(h.slicenumber,'String');
slicenumbervalue_num = str2double(slicenumbervalue);

% Proc
if checkreaddicom == 1 && checkphaseunwrapping == 0 && checkvsharp == 0 && checkilsqrqsm == 0 && checkpreprocessingval == 0 && checksubjectanalysisval == 0
    % Only read DICOM Images
    readdicomproc(workingdir, checkb0val, getnumcharvaluevalue, getfolderprefixvalue, getechoprefixvalue);
    
elseif checkreaddicom == 1 && checkphaseunwrapping == 1 && checkvsharp == 0 && checkilsqrqsm == 0 && checkpreprocessingval == 0 && checksubjectanalysisval == 0
    % Dicom Read + Unwrapping
    readdicomunwrapping(workingdir, checkb0val, getnumcharvaluevalue, getfolderprefixvalue, getechoprefixvalue);
    
elseif checkreaddicom == 1 && checkphaseunwrapping == 1 && checkvsharp == 1 && checkilsqrqsm == 0 && checkpreprocessingval == 0 && checksubjectanalysisval == 0
    % Dicom Read + Unwrapping + V-SHARP
    readdicomunwrappingvsharp(workingdir, checkb0val, getnumcharvaluevalue, getfolderprefixvalue, getechoprefixvalue);
    
elseif checkreaddicom == 1 && checkphaseunwrapping == 1 && checkvsharp == 1 && checkilsqrqsm == 1 && checkpreprocessingval == 0 && checksubjectanalysisval == 0
    % Dicom Read + Unwrapping + V-SHARP + iLSQR
    readdicomunwrappingvsharpilsqr(workingdir, checkb0val, getnumcharvaluevalue, getfolderprefixvalue, getechoprefixvalue);
    
elseif checkreaddicom == 1 && checkphaseunwrapping == 1 && checkvsharp == 1 && checkilsqrqsm == 1 && checkpreprocessingval == 1 && checksubjectanalysisval == 0
    % Dicom Read + Unwrapping + V-SHARP + iLSQR + Preprocessing
    readdicomunwrappingvsharpilsqr(workingdir,checkb0val);   
    preprocessing_singlefmrifile(tr_value_num, slicenumbervalue_num, workingdir);
    
elseif checkreaddicom == 1 && checkphaseunwrapping == 1 && checkvsharp == 1 && checkilsqrqsm == 1 && checkpreprocessingval == 1 && checksubjectanalysisval == 1
    % Dicom Read + Unwrapping + V-SHARP + iLSQR + Peprocessing + Subject Analysis
    readdicomunwrappingvsharpilsqr(workingdir, checkb0val, getnumcharvaluevalue, getfolderprefixvalue, getechoprefixvalue);
    preprocessing_singlefmrifile(tr_value_num, slicenumbervalue_num, workingdir);
    subjectlevel_singlefmrifile(tr_value_num, slicenumbervalue_num, workingdir);
    
else
    % Do Nothing
end


end