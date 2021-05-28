function gobuttonproc(hObject,eventdata, h)

h = guidata(hObject);

getselectmodality = get(h.modaloption, 'Value');
getselectanalysis = get(h.analysisoption, 'Value');
getselectprocessing = get(h.processingtypeoptions, 'Value');
getbrowsedirectory = get(h.browsedirupdate,'String');

if getselectmodality == 1 && getselectanalysis == 1 && getselectprocessing == 1
    disp('Single Modal/ MRS/ Single');
    singlemrsproc(getbrowsedirectory);
    
elseif getselectmodality == 1 && getselectanalysis == 1 && getselectprocessing == 2
    disp('Single Modal/ MRS/ Batch');
    singlemrsproc(getbrowsedirectory);
    
elseif getselectmodality == 1 && getselectanalysis == 2 && getselectprocessing == 1
    disp('Single Modal/ fMRI/ Single');
    singlefmriproc(getbrowsedirectory);
    
elseif getselectmodality == 1 && getselectanalysis == 2 && getselectprocessing == 2
    disp('Single Modal/ fMRI/ Batch');
    batchfmriproc(getbrowsedirectory);
    
elseif getselectmodality == 1 && getselectanalysis == 3 && getselectprocessing == 1
    disp('Single Modal/ MEG/ Single');
    singlemegproc(getbrowsedirectory);
    
elseif getselectmodality == 1 && getselectanalysis == 3 && getselectprocessing == 2
    disp('Single Modal/ MEG/ Batch');
    batchmegproc(getbrowsedirectory);
    
elseif getselectmodality == 1 && getselectanalysis == 4 && getselectprocessing == 1
    disp('Single Modal/ QSM/ Single');
    singleqsmprocessingproc(getbrowsedirectory);
    
elseif getselectmodality == 1 && getselectanalysis == 4 && getselectprocessing == 2
    disp('Single Modal/ QSM/ Batch');
    % bacthqsmprocessingproc(getbrowsedirectory);
    singleqsmprocessingproc(getbrowsedirectory);
    
elseif getselectmodality == 2 && getselectanalysis == 1 && getselectprocessing == 1
    disp('Multi Modal/ fMRI-MRS/ Single');
    singlefmrimrsproc(getbrowsedirectory);
    
elseif getselectmodality == 2 && getselectanalysis == 1 && getselectprocessing == 2
    disp('Multi Modal/ fMRI-MRS/ Batch');
    batchfmrimrsproc(getbrowsedirectory);
    
elseif getselectmodality == 2 && getselectanalysis == 2 && getselectprocessing == 1
    disp('Multi Modal/ MEG-MRS/ Single ');
    singlemegmrsproc(getbrowsedirectory);
    
elseif getselectmodality == 2 && getselectanalysis == 2 && getselectprocessing == 2
    disp('Multi Modal/ MEG-MRS/ Batch ');
    batchmegmrsproc(getbrowsedirectory);
    
elseif getselectmodality == 2 && getselectanalysis == 3 && getselectprocessing == 1
    disp('Multi Modal/ fMRI-QSM/ Single ');
    singleqsmfmriproc(getbrowsedirectory);
    
elseif getselectmodality == 2 && getselectanalysis == 3 && getselectprocessing == 2
    disp('Multi Modal/ fMRI-QSM/ Batch ');
    batchqsmfmriproc(getbrowsedirectory);
    
elseif getselectmodality == 2 && getselectanalysis == 4 && getselectprocessing == 1
    disp('Multi Modal/ MEG-fMRI/ Single ');
    singlemegfmriproc(getbrowsedirectory);
    
elseif getselectmodality == 2 && getselectanalysis == 4 && getselectprocessing == 2
    disp('Multi Modal/ MEG-fMRI/ Batch ');
    batchmegfmriproc(getbrowsedirectory);
    
    guidata(hObject,h)
    
end