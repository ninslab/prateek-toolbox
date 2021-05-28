function mars_blob_ui(action)
% Displays SPM results, and ROI menu in SPM input window
% FORMAT mars_blob_ui(action)
%
% This is the SPM2 / SPM5 version
%
% action     - action string; can be
%                'init'      - initialise results interface
%                'save_one'  - UI to save current cluster
%                'save_many' - UI to save all clusters
%
% This routine does SPM version specific stuff, the main
% work is in mars_blob2roi.m and mars_blobs2rois.m
%
% $Id: mars_blob_ui.m 184 2004-01-18 11:26:08Z matthewbrett $

if nargin < 1
    action = 'init';
end

errstr = sprintf(['''Cannot find xSPM struct in the workspace; '...
    'Please (re)run SPM results GUI''']);

switch lower(action)
    case 'init'
        try % and find valid SPM results stuff
            evalin('base', 'xSPM;');
            hReg = evalin('base', 'hReg;');
            spm_XYZreg('CleanReg',hReg);
            mars_blob_menu;
        catch % give up and get a new one
            mars_blob_ui('reinit');
        end
    case 'reinit'
        % Display SPM results
        evalin('base', '[hReg,xSPM,SPM] = spm_results_ui;');
        % Menu
        mars_blob_menu;
        mars_blob_ui('save_one');
    case 'save_one' % segment added by Saurav
        xSPM = evalin('base', 'xSPM', ['error(' errstr ')']);
        %-Get current location
        pt   = spm_results_ui('GetCoords');
        
        load TabDat.mat TabDat
        arr = TabDat.dat(:,5);
        
        % find the maximum element in the arraylist
        empties = cellfun('isempty', arr);
        arr(empties) = {NaN};
        arr1 = cell2mat(arr);
        [num, index] = max(arr1);
        
        % traceback to the actual coordinate from TabDat.mat
        pt = TabDat.dat{index,12};
        % save pt
        % mars_blob2roi(xSPM, roicoordinates);
        mars_blob2roi(xSPM, pt);
    case 'save_many'
        xSPM = evalin('base', 'xSPM', ['error(' errstr ')']);
        mars_blobs2rois(xSPM);
    otherwise
        error(['Worried by request for ' action]);
end
