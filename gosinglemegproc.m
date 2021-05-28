function gosinglemegproc(hObject, eventdata, h)

workingdir = get(h.browsedirectoryvalue, 'String');
getmeganalysisheadmodel = get(h.meganalysisheadmodel,'Value');
getmeganalysiscoregistration = get(h.meganalysiscoregistration, 'Value');
getmeganalysisforwardmodel = get(h.meganalysisforwardmodel, 'Value');
getmeganalysisinvertsion = get(h.meganalysisinvertsion, 'Value');
getmeganalysisresults = get(h.meganalysisresults, 'Value');

if getmeganalysisheadmodel == 1 && getmeganalysiscoregistration == 0 &&  getmeganalysisforwardmodel == 0 && getmeganalysisinvertsion == 0 && getmeganalysisresults == 0
    % Headmodel only
    megheadmodelproc(workingdir);
elseif getmeganalysisheadmodel == 1 && getmeganalysiscoregistration == 1 &&  getmeganalysisforwardmodel == 0 && getmeganalysisinvertsion == 0 && getmeganalysisresults == 0
    % Headmodel + Registration
    megcoregistrarion(workingdir);
elseif getmeganalysisheadmodel == 1 && getmeganalysiscoregistration == 1 &&  getmeganalysisforwardmodel == 1 && getmeganalysisinvertsion == 0 && getmeganalysisresults == 0
    % Headmodel + Registration + Forward Model
    megforwardmodel(workingdir);
elseif getmeganalysisheadmodel == 1 && getmeganalysiscoregistration == 1 &&  getmeganalysisforwardmodel == 1 && getmeganalysisinvertsion == 1 && getmeganalysisresults == 0
    % Headmodel + Registration + Forward Model + Inversion
    meginversionmodel(workingdir);
elseif getmeganalysisheadmodel == 1 && getmeganalysiscoregistration == 1 &&  getmeganalysisforwardmodel == 1 && getmeganalysisinvertsion == 1 && getmeganalysisresults == 1
    % Headmodel + Registration + Forward Model + Inversion + Results
    meganalysisprocedure(workingdir);
else
    % Do Nothing
end

end