function megprocessing(mrifile, megfilename, megrawfiledir)

% Intitialize EEG SPM toolbox
spm('defaults', 'eeg');
spm_jobman('initcfg');

a = cd;

% Initialize Folders and Files
megdata = megfilename;
mrifileread = ft_read_mri(mrifile);

% MEG Processing
cd(megrawfiledir);
inp = spm_eeg_convert(megdata);
cd(a);

direc5 = dir(megrawfiledir);
matfileraw = fullfile(megrawfiledir, direc5(4).name);

% Load .matfile
inpmatfile = spm_eeg_load(matfileraw);

D = matfileraw;

% MEG Details of Data
fprintf('###################################################### \n');
fprintf('File Details \n\n');
display(inpmatfile);
fprintf('###################################################### \n');

%Initialize Parameters
S = [];
S.task = 'project3D';
S = [];
S.task = 'project3D';
S.modality = 'MEG';
S.updatehistory = 1;
S.D = D;
D = spm_eeg_prep(S);
save(D);

% Begin Processing
%--------------------------------------------------------------------------
matlabbatch{1}.spm.meeg.source.headmodel.D = {fullfile(D.path, D.fname)};
%--------------------------------------------------------------------------
matlabbatch{1}.spm.meeg.source.headmodel.val = 1;
matlabbatch{1}.spm.meeg.source.headmodel.comment = '';
matlabbatch{1}.spm.meeg.source.headmodel.meshing.meshes.template = 1;
matlabbatch{1}.spm.meeg.source.headmodel.meshing.meshes.mri = mrifileread;
matlabbatch{1}.spm.meeg.source.headmodel.meshing.meshres = 3;
%--------------------------------------------------------------------------
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).fidname = 'Nasion';
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).specification.select = 'nas';
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).fidname = 'LPA';
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).specification.select = 'lpa';
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).fidname = 'RPA';
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).specification.select = 'rpa';
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.useheadshape = 1;
%--------------------------------------------------------------------------
matlabbatch{1}.spm.meeg.source.headmodel.forward.eeg = '3-Shell Sphere';
matlabbatch{1}.spm.meeg.source.headmodel.forward.meg = 'Single Shell';
%--------------------------------------------------------------------------
matlabbatch{1}.spm.meeg.source.headmodel.invert.reconstruction = 'Imaging';
matlabbatch{1}.spm.meeg.source.headmodel.invert.model = 'Standard';
%-------------------------------------------------------------------------- 
matlabbatch{2}.spm.meeg.source.invert.D(1) = cfg_dep('Head model specification: M/EEG dataset(s) with a forward model',substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','D'));
matlabbatch{2}.spm.meeg.source.invert.val = 1;
matlabbatch{2}.spm.meeg.source.invert.whatconditions.all = 1;
matlabbatch{2}.spm.meeg.source.invert.isstandard.standard = 1;
matlabbatch{2}.spm.meeg.source.invert.modality = {'MEG','MEGPLANAR'};

matlabbatch{3}.spm.meeg.source.results.D(1) = cfg_dep('Source inversion: M/EEG dataset(s) after imaging source reconstruction',substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','D'));
matlabbatch{3}.spm.meeg.source.results.val = 1;
matlabbatch{3}.spm.meeg.source.results.woi = [0 350]; % time of interest
matlabbatch{3}.spm.meeg.source.results.foi = [0 0]; % frequency window specify
matlabbatch{3}.spm.meeg.source.results.ctype = 'trials'; % 'evoked' 'induced' or single 'trials'
matlabbatch{3}.spm.meeg.source.results.space = 1; % 1 = MNI or Native
matlabbatch{3}.spm.meeg.source.results.format = 'image';
matlabbatch{3}.spm.meeg.source.results.smoothing = 12; % mm voxel smoothing value (the default is 8x8x8 mm
%however the setting for this script is 12x12x12 mm)

spm_jobman('serial',matlabbatch);

end