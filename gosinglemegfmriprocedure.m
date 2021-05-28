function gosinglemegfmriprocedure(hObject, eventdata, h)

checkpreprocessingval = get(h.procpreprocessing, 'Value');
checksubjectanalysisval = get(h.subjectlevelanalysis ,'Value');
tr_val = get(h.trvalue, 'String');
tr_value_num = str2double(tr_val);
slicenumbervalue = get(h.slicenumber,'String');
slicenumbervalue_num = str2double(slicenumbervalue);
workingdir = get(h.browsedirectoryvalue, 'String');
getmeganalysis = get(h.meganalysis,'Value');


if getmeganalysis == 1 && checkpreprocessingval == 0 && checksubjectanalysisval == 0
    % MEG Analysis Only
    meganalysisprocedure(workingdir);
    
elseif getmeganalysis == 1 && checkpreprocessingval == 1 && checksubjectanalysisval == 0
    % MEG + fMRI Preprocessing
    meganalysisprocedure(workingdir);
    preprocessing_singlefmrifile(tr_value_num, slicenumbervalue_num, workingdir);
    
elseif getmeganalysis == 1 && checkpreprocessingval == 1 && checksubjectanalysisval == 1
    % MEG + fMRI Preprocessing + Subject level Analysis
    meganalysisprocedure(workingdir);
    completefmriproc_singlefmrifile(tr_value_num, slicenumbervalue_num, workingdir);
    
else
    % Do Nothing
end

end