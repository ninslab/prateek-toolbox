function filestructgenerate22(dir_value)

h.figure = figure('position' , [600 440 400 200]);
set(h.figure, 'Color', [0.43 0.76 0.70]);

h.numberofsubjects = uicontrol(h.figure ,'Style','text',...
    'String','Label (MRS Mask)',...
    'Position',[20 160 150 20]);

h.numberofsubjectsvalue = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[200 160 150 20]);

h.subjectcodeprompt = uicontrol(h.figure ,'Style','text',...
    'String','Subject Code',...
    'Position',[20 120 150 20]);

h.subjectcodeaddition = uicontrol(h.figure ,'Style','edit',...
    'String','',...
    'Position',[200 120 150 20]);

h.numberofsubjects = uicontrol(h.figure ,'Style','text',...
    'String','Upload Data',...
    'Position',[20 80 150 20]);

h.megdata = uicontrol(h.figure ,'Style','pushbutton',...
    'String','MEG',...
    'Position',[200 80 60 20]);

set(h.megdata,'callback', {@megdataproc,h});

h.mri_meg_data = uicontrol(h.figure ,'Style','pushbutton',...
    'String','MRI (MEG)',...
    'Position',[270 80 80 20]);

set(h.mri_meg_data,'callback', {@mri_meg_dataproc,h});

h.mrs_meg_data = uicontrol(h.figure ,'Style','pushbutton',...
    'String','MRS',...
    'Position',[200 40 60 20]);

set(h.mrs_meg_data,'callback', {@mrs_meg_dataproc,h});

h.mri_mrs_meg_data = uicontrol(h.figure ,'Style','pushbutton',...
    'String','MRI (MRS)',...
    'Position',[270 40 80 20]);

h.addsubjectcode = uicontrol(h.figure ,'Style','pushbutton',...
    'String','Add',...
    'Position',[200 5 150 20]);


set(h.mri_mrs_meg_data,'callback', {@mri_mrs_meg_dataproc,h});
set(h.addsubjectcode,'callback', {@addsubjectcode_meg_mriproc,h});

end