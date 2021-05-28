function MRS_mask_normalize(subject_dir,mrs_mask_raw,mri_filename,string)

% This code converts the MRS voxel mask in the Subject�s native space to standard MNI space.
% The code estimates the transformation matrix required to convert the T1-3D image into standard space and
% then applies this transformation matrix to normalize the MRS voxel mask.
% Input: list of subject directories, raw MRS voxel filenames, and matching MRI filenames as charater arrays
% Output: Normalized Independent masks and T1-overlapped MRS masks of subjects in MNI space


spm ('Defaults','fMRI')
spm_jobman('initcfg')

% spm folder initialization
% spmpathfile = toolboxdir('spm12');
spmpathfile = fullfile(pwd,'spm12');
pathuse = fullfile(spmpathfile,'tpm','TPM.nii');

for i=1:length(mrs_mask_raw)
    
    % Define MRS path
    if ~isempty(strfind(char(mrs_mask_raw(i)),string))
        mrs_path(i)=fullfile(subject_dir(i),'MRS',string);
        region=string;
    elseif ~isempty(strfind(char(mrs_mask_raw(i)),'RH'))
        mrs_path(i)=fullfile(subject_dir(i),'MRS','RH');
        region='RH';
    elseif ~isempty(strfind(char(mrs_mask_raw(i)),'PCC'))
        mrs_path(i)=fullfile(subject_dir(i),'MRS','PCC');
        region='PCC';
    end
    
    mri_path = fullfile(subject_dir(i),'MRI','MRS');
    mrs_filename(i) = fullfile(mrs_path(i),mrs_mask_raw(i));
    mri_filename(i) = fullfile(mri_path,mri_filename(i));
    
    im2write={char(mri_filename(i));char(mrs_filename(i))};
    
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = mri_filename(i);
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = im2write;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
    % matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {'/usr/local/MATLAB/R2017b/toolbox/spm12/spm12/tpm/TPM.nii'};
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {pathuse};
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-90 -126 -72
        90 90 108];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';
    
    mrs_norm(i) = fullfile(mrs_path(i),strcat('w',mrs_mask_raw(i)));
    mri_norm(i) = fullfile(mri_path,strcat('w',mri_filename(i)));
    
    spm_jobman('run',matlabbatch)
    
    V2=spm_vol(char(mrs_norm(i)));               % Reading the normalized (T1 image and the MASK combined) file (HU2044_Mask_LVC_T1.nii)
    [maskT1,~]=spm_read_vols(V2);
    
    % Converting Mask+T1 into only binary Mask
    maskT1(maskT1<1)=0;
    maskT1(maskT1>1)=1;
    
    fidoutmask=fullfile(mrs_path(i),strcat(region,'_mask_norm.nii'));
    Mask_Nor.fname=char(fidoutmask);
    Mask_Nor.descrip='MRS_Mask_Normalized';
    Mask_Nor.dim=V2.dim;
    Mask_Nor.dt=V2.dt;
    Mask_Nor.mat=V2.mat;
    Mask_Nor=spm_write_vol(Mask_Nor,maskT1);
    
end
end
