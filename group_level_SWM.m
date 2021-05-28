%Performs group analysis on multiple subjects pertinent to a specific
%experiment and provide concentrated activation.

% Author:
% Dr.Pravat Mandal,
% Saurav Roy,
% Neuroimaging and NeuroSpectroscopy Lab,
% National Brain Research Centre,
% Manesar

function group_level_SWM(common_dir_grp,subject_dir)

dir_1 = cd;

main_dir=fullfile(common_dir_grp,'Main');

spm('Defaults','fMRI');
spm_jobman('initcfg');

for sn=1:length(subject_dir)
    
    main_sub_dir{sn} = fullfile(subject_dir{sn},'fMRI','Analysis');
    main_file{sn}=spm_select('FPList',main_sub_dir{sn},'con_0001.nii');
    
end

main_list=main_file;

dirs=struct('M',main_dir);
Cond_dir=fieldnames(dirs);
lists=struct('M',main_list);
Cond_list=fieldnames(lists);

% SIngle t-test for Encoding, Maintenance and Retrieval
for i=1:numel(Cond_list)
    
    matlabbatch_1{1}.spm.stats.factorial_design.dir = {dirs.(Cond_dir{i})};
    matlabbatch_1{1}.spm.stats.factorial_design.des.t1.scans = {lists.(Cond_list{i})}';
    matlabbatch_1{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch_1{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch_1{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch_1{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch_1{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch_1{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch_1{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch_1{1}.spm.stats.factorial_design.globalm.glonorm = 1;
    matlabbatch_1{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch_1{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch_1{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch_1{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch_1{3}.spm.stats.con.consess{1}.tcon.name = 'Encode - Baseline';
    matlabbatch_1{3}.spm.stats.con.consess{1}.tcon.weights = 1;
    matlabbatch_1{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch_1{3}.spm.stats.con.delete = 0;
    matlabbatch_1{4}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch_1{4}.spm.stats.results.conspec.titlestr = '';
    matlabbatch_1{4}.spm.stats.results.conspec.contrasts = Inf;
    matlabbatch_1{4}.spm.stats.results.conspec.threshdesc = 'FWE';
    matlabbatch_1{4}.spm.stats.results.conspec.thresh = 0.05;
    matlabbatch_1{4}.spm.stats.results.conspec.extent = 0;
    matlabbatch_1{4}.spm.stats.results.conspec.conjunction = 1;
    matlabbatch_1{4}.spm.stats.results.conspec.mask.none = 1;
    matlabbatch_1{4}.spm.stats.results.units = 1;
    matlabbatch_1{4}.spm.stats.results.print = 'ps';
    matlabbatch_1{4}.spm.stats.results.write.none = 1;
    spm_jobman('run',matlabbatch_1)
    
end

% %% F-Contrast for Main_Effect - One-way ANOVA
%
% matlabbatch_2{1}.spm.stats.factorial_design.dir = {dirs.(Cond_dir{4})};
% matlabbatch_2{1}.spm.stats.factorial_design.des.anova.icell(1).scans = {lists.(Cond_list{1})}';
% matlabbatch_2{1}.spm.stats.factorial_design.des.anova.icell(2).scans = {lists.(Cond_list{2})}';
% matlabbatch_2{1}.spm.stats.factorial_design.des.anova.icell(3).scans = {lists.(Cond_list{3})}';
% matlabbatch_2{1}.spm.stats.factorial_design.des.anova.dept = 0;
% matlabbatch_2{1}.spm.stats.factorial_design.des.anova.variance = 1;
% matlabbatch_2{1}.spm.stats.factorial_design.des.anova.gmsca = 0;
% matlabbatch_2{1}.spm.stats.factorial_design.des.anova.ancova = 0;
% matlabbatch_2{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
% matlabbatch_2{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
% matlabbatch_2{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
% matlabbatch_2{1}.spm.stats.factorial_design.masking.im = 1;
% matlabbatch_2{1}.spm.stats.factorial_design.masking.em = {''};
% matlabbatch_2{1}.spm.stats.factorial_design.globalc.g_omit = 1;
% matlabbatch_2{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
% matlabbatch_2{1}.spm.stats.factorial_design.globalm.glonorm = 1;
% matlabbatch_2{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
% matlabbatch_2{2}.spm.stats.fmri_est.write_residuals = 0;
% matlabbatch_2{2}.spm.stats.fmri_est.method.Classical = 1;
% matlabbatch_2{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
% matlabbatch_2{3}.spm.stats.con.consess{1}.fcon.name = 'Main_Effect';
% matlabbatch_2{3}.spm.stats.con.consess{1}.fcon.weights = [1 0 0
%                                                         0 1 0
%                                                         0 0 1];
% matlabbatch_2{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
% matlabbatch_2{3}.spm.stats.con.delete = 0;
% matlabbatch_2{4}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
% matlabbatch_2{4}.spm.stats.results.conspec.titlestr = '';
% matlabbatch_2{4}.spm.stats.results.conspec.contrasts = Inf;
% matlabbatch_2{4}.spm.stats.results.conspec.threshdesc = 'FWE';
% matlabbatch_2{4}.spm.stats.results.conspec.thresh = 0.05;
% matlabbatch_2{4}.spm.stats.results.conspec.extent = 0;
% matlabbatch_2{4}.spm.stats.results.conspec.conjunction = 1;
% matlabbatch_2{4}.spm.stats.results.conspec.mask.none = 1;
% matlabbatch_2{4}.spm.stats.results.units = 1;
% matlabbatch_2{4}.spm.stats.results.print = 'ps';
% matlabbatch_2{4}.spm.stats.results.write.none = 1;
%
%
% spm_jobman('run',matlabbatch_2)


cd(dir_1);

end