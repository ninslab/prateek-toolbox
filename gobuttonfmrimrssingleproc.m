function gobuttonfmrimrssingleproc(hObject, eventdata, h)

checkpreprocessingval = get(h.procpreprocessing, 'Value');
checksubjectanalysisval = get(h.subjectlevelanalysis ,'Value');
% checkgroupanalysisval = get(h.grouplevelanalysis, 'Value');
tr_val = get(h.trvalue, 'String');
tr_value_num = str2double(tr_val);
slicenumbervalue = get(h.slicenumber,'String');
slicenumbervalue_num = str2double(slicenumbervalue);
workingdir = get(h.browsedirectoryvalue, 'String');
getlabelval = get(h.labelvalue, 'String');
rawmaskstatusvalue = get(h.rawmaskstatus, 'Value');
normmaskstatusvalue = get(h.normmaskstatus, 'Value');
resultmaskstatusvalue = get(h.resultmaskstatus, 'Value');

if checkpreprocessingval == 1 && checksubjectanalysisval == 0 && rawmaskstatusvalue == 0 && normmaskstatusvalue == 0 && resultmaskstatusvalue == 0
    fprintf('Pre-Processing Only \n');
    preprocessing_singlefmrifile(tr_value_num, slicenumbervalue_num, workingdir);
elseif checkpreprocessingval == 1 && checksubjectanalysisval == 1 && rawmaskstatusvalue == 0 && normmaskstatusvalue == 0 && resultmaskstatusvalue == 0
    fprintf('Pre-processing + Subject Level Analysis \n');
    completefmriproc_singlefmrifile(tr_value_num, slicenumbervalue_num, workingdir);
elseif checkpreprocessingval == 1 && checksubjectanalysisval == 1 && rawmaskstatusvalue == 1 && normmaskstatusvalue == 0 && resultmaskstatusvalue == 0 
    fprintf('Pre-Processing + Subject Level Analysis + Raw Mask \n');
    rawmrsmaskcombined(tr_value_num, slicenumbervalue_num, workingdir, getlabelval);
elseif checkpreprocessingval == 1 && checksubjectanalysisval == 1 && rawmaskstatusvalue == 1 && normmaskstatusvalue == 1 && resultmaskstatusvalue == 0 
    fprintf('Pre-Processing + Subject Level Analysis + Raw Mask + Normalized Mask \n');
    normmaskcombined(tr_value_num, slicenumbervalue_num, workingdir, getlabelval);
elseif checkpreprocessingval == 1 && checksubjectanalysisval == 1 && rawmaskstatusvalue == 1 && normmaskstatusvalue == 1 && resultmaskstatusvalue == 1
    fprintf('Pre-Processing + Subject Level Analysis + Raw Mask + Normalized Mask + Results \n');
    performallfmrimrsproc(tr_value_num, slicenumbervalue_num, workingdir, getlabelval);
else
    %Do Nothing
end

end