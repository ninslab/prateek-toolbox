function filestructgenerate23(dir_value)

h.figure = figure('position' , [600 440 400 200]);
set(h.figure, 'Color', [0.43 0.76 0.70]);

% h.numberofsubjects = uicontrol(h.figure ,'Style','text',...
%     'String','Label (MRS Mask)',...
%     'Position',[20 160 150 20]);
% 
% h.numberofsubjectsvalue = uicontrol(h.figure ,'Style','edit',...
%     'String','',...
%     'Position',[200 160 150 20]);

h.subjectcodeprompt = uicontrol(h.figure ,'Style','text',...
    'String','Subject Code',...
    'Position',[20 120 150 20]);

h.subjectcodeaddition = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[200 120 150 20]);

h.numberofsubjects = uicontrol(h.figure ,'Style','text',...
    'String','Upload Data',...
    'Position',[20 80 150 20]);

h.fmri_qsmdata = uicontrol(h.figure ,'Style','pushbutton',...
    'String','fMRI',...
    'Position',[200 80 60 20]);

set(h.fmri_qsmdata,'callback', {@fmri_qsmdataproc,h});

h.mri_fmri_qsm_data = uicontrol(h.figure ,'Style','pushbutton',...
    'String','MRI (fMRI)',...
    'Position',[270 80 80 20]);

set(h.mri_fmri_qsm_data,'callback', {@mri_fmri_qsm_dataproc,h});

h.exceldata_fmri = uicontrol(h.figure ,'Style','pushbutton',...
    'String','Onset details (.xlsx)',...
    'Position',[200 55 150 20]);

set(h.exceldata_fmri, 'callback', {@excel_response_call,h})

h.qsm_data = uicontrol(h.figure ,'Style','pushbutton',...
    'String','QSM',...
    'Position',[200 30 60 20]);

set(h.qsm_data,'callback', {@qsm_dataproc,h});

h.mri_qsm_data = uicontrol(h.figure ,'Style','pushbutton',...
    'String','MRI (QSM)',...
    'Position',[270 30 80 20]);

h.addsubjectcode = uicontrol(h.figure ,'Style','pushbutton',...
    'String','Add',...
    'Position',[200 5 150 20]);

set(h.mri_qsm_data,'callback', {@mri_qsm_dataproc,h});
set(h.addsubjectcode,'callback', {@addqsm_mri_subjectproc,h});

end