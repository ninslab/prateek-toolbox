%Performs preprocessing on multiple subjects pertinent to a specific
%experiment and provide concentrated activation.

% Author:
% Saurav Roy,
% Neuroimaging and NeuroSpectroscopy Lab,
% National Brain Research Centre,
% Manesar


% This code will run the spm batch preprocessing steps: Slice Timing Correction,
% Realignment, Coregistration, Segmentation, functional Normalization, Smoothing, and
% structural Normalization sequentially for all the subjects.
% Input: list of subject directories and subject codes as charater arrays
% Output: preprocessed functional and structural files generated in respective folders

function preprocessing_SWM(subject_dir, subject_code,slicenumbervalue_num, ptav,ptbv,ptcv,tra,ref_slice)

if nargin < 2
    disp('Please specify the subject_dir, subject_code');
    return
elseif length(subject_dir) ~= length(subject_code)
    disp('Inconsistency in the list of subject_dir and subject_code');
    return
elseif ~iscellstr(subject_dir) || ~iscellstr(subject_code)
    disp('Please specify the subject_dir and subject_code as cell strings');
    return
end

spm('Defaults','fMRI');
spm_jobman('initcfg');

% spmpathfile = toolboxdir('spm12');
spmpathfile = fullfile(pwd,'spm12');
pathuse = fullfile(spmpathfile,'tpm','TPM.nii');

ta = tra - (tra/slicenumbervalue_num);

itr = 1: slicenumbervalue_num;

for sn = 1:length(subject_dir)
    
    epi_dir = fullfile(subject_dir{sn},'fMRI','EPI');
    no_vol = cal_no_vol(subject_dir{sn}, ptav, ptbv, ptcv);
    epi_file = spm_select('ExtFPList',epi_dir,'^HU.*nii',1:no_vol);
    t1_dir = fullfile(subject_dir{sn},'MRI','fMRI');
    t1_file = spm_select('ExtFPList', t1_dir,'.nii',1);

    matlabbatch = [];
    matlabbatch{1}.spm.temporal.st.scans = {cellstr(epi_file)};
    matlabbatch{1}.spm.temporal.st.nslices = slicenumbervalue_num;
    matlabbatch{1}.spm.temporal.st.tr = tra;
    matlabbatch{1}.spm.temporal.st.ta = ta;
    matlabbatch{1}.spm.temporal.st.so = itr;
    matlabbatch{1}.spm.temporal.st.refslice = ref_slice;
    matlabbatch{1}.spm.temporal.st.prefix = 'a';
    
    matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.sep = 4;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.interp = 2;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    
    matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
    matlabbatch{3}.spm.spatial.coreg.estwrite.source = cellstr(t1_file);
    matlabbatch{3}.spm.spatial.coreg.estwrite.other = {''};
    matlabbatch{3}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{3}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{3}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{3}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{3}.spm.spatial.coreg.estwrite.roptions.interp = 4;
    matlabbatch{3}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{3}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{3}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
    
    matlabbatch{4}.spm.spatial.preproc.channel.vols(1) = cfg_dep('Coregister: Estimate & Reslice: Resliced Images', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rfiles'));
    matlabbatch{4}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{4}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{4}.spm.spatial.preproc.channel.write = [0 0];
    matlabbatch{4}.spm.spatial.preproc.tissue(1).tpm = {strcat(pathuse,',1')};
    % matlabbatch{4}.spm.spatial.preproc.tissue(1).tpm = {'/usr/local/MATLAB/R2017b/toolbox/spm12/tpm/TPM.nii,1'};
    matlabbatch{4}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{4}.spm.spatial.preproc.tissue(1).native = [1 0];
    matlabbatch{4}.spm.spatial.preproc.tissue(1).warped = [0 0];
    matlabbatch{4}.spm.spatial.preproc.tissue(2).tpm = {strcat(pathuse,',2')};
    matlabbatch{4}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{4}.spm.spatial.preproc.tissue(2).native = [1 0];
    matlabbatch{4}.spm.spatial.preproc.tissue(2).warped = [0 0];
    matlabbatch{4}.spm.spatial.preproc.tissue(3).tpm = {strcat(pathuse,',3')};
    matlabbatch{4}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{4}.spm.spatial.preproc.tissue(3).native = [1 0];
    matlabbatch{4}.spm.spatial.preproc.tissue(3).warped = [0 0];
    matlabbatch{4}.spm.spatial.preproc.tissue(4).tpm = {strcat(pathuse,',4')};
    matlabbatch{4}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{4}.spm.spatial.preproc.tissue(4).native = [1 0];
    matlabbatch{4}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{4}.spm.spatial.preproc.tissue(5).tpm = {strcat(pathuse,',5')};
    matlabbatch{4}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{4}.spm.spatial.preproc.tissue(5).native = [1 0];
    matlabbatch{4}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{4}.spm.spatial.preproc.tissue(6).tpm = {strcat(pathuse,',6')};
    matlabbatch{4}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{4}.spm.spatial.preproc.tissue(6).native = [0 0];
    matlabbatch{4}.spm.spatial.preproc.tissue(6).warped = [0 0];
    matlabbatch{4}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{4}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{4}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{4}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{4}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{4}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{4}.spm.spatial.preproc.warp.write = [0 1];
    
    matlabbatch{5}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
    matlabbatch{5}.spm.spatial.normalise.write.woptions.bb = [-90 -126 -72
                                                               90 90 108];
    matlabbatch{5}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
    matlabbatch{5}.spm.spatial.normalise.write.woptions.interp = 4;
    matlabbatch{5}.spm.spatial.normalise.write.woptions.prefix = 'w';
    
    matlabbatch{6}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    matlabbatch{6}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{6}.spm.spatial.smooth.dtype = 0;
    matlabbatch{6}.spm.spatial.smooth.im = 0;
    matlabbatch{6}.spm.spatial.smooth.prefix = 's';
   
    matlabbatch{7}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
    matlabbatch{7}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Coregister: Estimate & Reslice: Resliced Images', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rfiles'));
    matlabbatch{7}.spm.spatial.normalise.write.woptions.bb = [-90 -126 -72
                                                               90 90 108];
    matlabbatch{7}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
    matlabbatch{7}.spm.spatial.normalise.write.woptions.interp = 4;
    matlabbatch{7}.spm.spatial.normalise.write.woptions.prefix = 'w';
    spm_jobman('run', matlabbatch);
    
    
end
end