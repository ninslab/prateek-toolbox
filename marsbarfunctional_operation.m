function marsbarfunctional_operation(hObject, eventdata, h, p_value)

% initial keys
%---------------------------------------------
key1 = 'fMRI'; % folder prefix
key2 = 'Analysis'; % folder prefix
key3 = 'Results';

% Subject directory initialisation
% initialDir = '/media/ninslab/DATA/Miscellany/TestingFolder/PrateekTestGround';
%---------------------------------------------
codedir = cd;
setappdata(0,'codedirec',codedir);
initialDir = getappdata(0, 'dirmain');
subjectDir = fullfile(initialDir, 'Subjects');
subjectDirContents = dir(subjectDir);
len = length(subjectDirContents);

% Masking algorithm
%---------------------------------------------
a = cd;
% Parsing
for i = 3 : len
    
    primarySubjects = subjectDirContents(i).name;
    primarySubjectslocation = fullfile(subjectDir, primarySubjects);
    spmfilelocation = fullfile(primarySubjectslocation, key1, key2);
    setappdata(0, 'SPMlocationVar', spmfilelocation);
    
    % marsbar Processing pipeline
    % mars_blob_ui('init'); % initialize
    % mars_blob_ui('save_one');
    % [SPM,xSPM] = spm_getSPM();
    % [xSPM,SPM] = spm_results_ui();
    % TabDat = spm_list('list', xSPM); % added by Saurav
    
    % Masking Function
    %---------------------------------------------
    [SPM,xSPM] = spm_getSPM(); % initialize function
    
    % Save coordinates
    %---------------------------------------------
    try
        TabDat = spm_list('list',xSPM);
    catch
        warning('Warning: Do not be worried.. It does not matter');
    end
    
    % Get all relevant ROI coordinates
    %---------------------------------------------
    load TabDat.mat TabDat
    arr = TabDat.dat(:,5);
    arrcoordinates = TabDat.dat(:,12);
    
    % find the maximum element in the arraylist
    %---------------------------------------------
    empties = cellfun('isempty', arr);
    arr(empties) = {NaN};
    arr1 = cell2mat(arr);
    [num, index] = max(arr1);
    
    % traceback to the actual coordinate from TabDat.mat
    %---------------------------------------------
    pt = TabDat.dat{index,12};
    save pt
    % mars_blob2roi(xSPM, roicoordinates);
    mars_blob2roi(xSPM, pt);
    
    
%     % Added today : 13/05/20
%     %----------------------------------------------
%     img = normalfmridata;
%     if isempty(img),return,end
%     sp = mars_space(img);
%     
%     roi = load('Analysis_roi.mat');
%     if isempty(roi),return,end
%     %[pn fn ext] = fileparts(roi);
%     roi = maroi('load', roi);
%     
%     
%     fname = 'testimagesave.nii';
%     save_as_image(roi, fname, sp);
%     
%     %----------------------------------------------
    
    
    % Save mask roi into Results folder
    %---------------------------------------------
    resultsFolderdir = fullfile(primarySubjectslocation,'Results');
    mkdir(fullfile(resultsFolderdir));
    roi_filename = fullfile(spmfilelocation,'Analysis.nii');
    movefile(roi_filename, resultsFolderdir);    
end
cd(a);
end



