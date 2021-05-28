function gobuttonfmrianalysisgroupproc(hObject, eventdata, h)

checkpreprocessingval = get(h.procpreprocessing, 'Value');
checksubjectanalysisval = get(h.subjectlevelanalysis ,'Value');
% checkgroupanalysisval = get(h.grouplevelanalysis, 'Value');
tr_val = get(h.trvalue, 'String');
tr_value_num = str2double(tr_val);
slicenumbervalue = get(h.slicenumber,'String');
slicenumbervalue_num = str2double(slicenumbervalue);
workingdir = get(h.browsedirectoryvalue, 'String');

if checkpreprocessingval == 1 && checksubjectanalysisval == 0
    disp('Preprocessing Only............\n');
    preprocessing_singlefmrifile(tr_value_num, slicenumbervalue_num, workingdir);
    
elseif checkpreprocessingval == 0 && checksubjectanalysisval == 1
    disp('Subject Level Analysis Only..........\n');
    subjectlevel_singlefmrifile(tr_value_num, slicenumbervalue_num, workingdir);
    
    % elseif checkpreprocessingval == 0 && checksubjectanalysisval == 0 && checkgroupanalysisval == 1
    %     disp('Group Level Analysis Only............\n');
    %     groupfmriproc_singlefmrifile(tr_value_num, slicenumbervalue_num, workingdir);
    
elseif checkpreprocessingval == 1 && checksubjectanalysisval == 1
    disp('Preprocessing + Subject Level Analysis......\n');
    completefmriproc_singlefmrifile(tr_value_num, slicenumbervalue_num, workingdir);
    
    % elseif checkpreprocessingval == 1 && checksubjectanalysisval == 1 && checkgroupanalysisval == 1
    %     disp('Preprocessing + Subject Level Analysis + Group Level Analysis');
    %     grouplevel_singlefmrifile(tr_value_num, slicenumbervalue_num, workingdir);
    
else
    msgbox('Revise your choice selection');
    
end

end