function megprocessingheadmodel(mrifile, megfilename, megrawfiledir)

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

spm_jobman('serial',matlabbatch);

end