% This code will assess the brain activity in response to Sternberg working memory task and create subject specific activation maps.
% The information regarding the onsets, durations and reaction times of the working memory paradigm
% (Encoding, Maintenance and Retrieval) have to be fed into the code via excel sheets.

% Input: Common directory (check Figure1), list of subject directories as charater arrays,
%         Excel sheet containing onsets, durations and reaction times of the working memory paradigm
% Output: subject-level activation maps for the Sternberg working memory paradigm


% Author:
% Saurav Roy,
% Neuroimaging and NeuroSpectroscopy Lab,
% National Brain Research Centre,
% Manesar

function subject_level_SWM(subject_dir, subject_code , slicenumbervalue_num, ptav,ptbv,ptcv,tra, ref_slice)

dirt= cd;

spm('Defaults','fMRI');
spm_jobman('initcfg');

for sn = 1:length(subject_dir)
    
    no_vol = cal_no_vol(subject_dir{sn},ptav, ptbv, ptcv);
    output_dir = fullfile(subject_dir{sn},'fMRI', 'Analysis');
    preprocessed_epi_dir = fullfile(subject_dir{sn},'fMRI', 'EPI');
    
    %---- Excel shee path------
    a = cd;
    str_search = fullfile(subject_dir{sn});
    cd(str_search);
    d = dir('*.xlsx');
    excel_filepath = fullfile(d.folder,d.name);
    cd(a);
    %--------------------------
    
    fmri_preprocessed_file = spm_select('ExtFPList',preprocessed_epi_dir,'^swraHU.*nii',1:no_vol);
    
    head_motion_file = (spm_select('FPList',preprocessed_epi_dir,'^rp_.*txt'));
    
    % SWM_result=xlsread(strcat(subject_dir{sn},'/',subject_code{sn},'_SWM_results'),'All_Blocks','A2:D61');
    % SWM_result=xlsread(strcat(fullfile(subject_dir{sn},subject_code{sn}),'_SWM_results'),'All_Blocks','A2:B241');
    % SWM_result=xlsread(strcat(fullfile(subject_dir{sn},subject_code{sn}),'_SWM_results'));
    % fmri_response_sheet = getappdata(0,'excel_fmri_response_sheet'); % Call response sheet location
    SWM_result=xlsread(excel_filepath);
    
    main_onset=SWM_result(:,1);
    main_time = SWM_result(:,2);
    
    matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(output_dir);
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = tra;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = slicenumbervalue_num;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = ref_slice;
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(fmri_preprocessed_file);
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'Main';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = main_onset;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = main_time;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(head_motion_file);
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Main';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0 0];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    
    matlabbatch{4}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{4}.spm.stats.results.conspec.titlestr = 'SWM';
    matlabbatch{4}.spm.stats.results.conspec.contrasts = Inf;
    matlabbatch{4}.spm.stats.results.conspec.threshdesc = 'FWE';
    matlabbatch{4}.spm.stats.results.conspec.thresh = 0.05;
    matlabbatch{4}.spm.stats.results.conspec.extent = 0;
    matlabbatch{4}.spm.stats.results.conspec.conjunction = 1;
    matlabbatch{4}.spm.stats.results.conspec.mask.none = 1;
    matlabbatch{4}.spm.stats.results.units = 1;
    matlabbatch{4}.spm.stats.results.print = 'ps';
    matlabbatch{4}.spm.stats.results.write.none = 1;
    spm_jobman('run', matlabbatch);
end

cd(dirt);

end
