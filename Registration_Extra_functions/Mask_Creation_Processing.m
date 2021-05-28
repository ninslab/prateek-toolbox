function Mask_Creation_Processing(sub_dir,sub_code,mrs_filename, mri_filename)

%% Files Input and naming

% Example names:
% sub_dir='F:\NBRC\fMRI-MRI_Pilot_Study\Preprocessing4\HU2044\';
% sub_code='HU2044';
% mrs_filename='HU2044_PRAVAT_06_07_15_WIP_LVC-MEGA-GABA_6_2_raw_act.spar'
% mri_filename='HU2044_PRAVAT_06_07_15_WIP_T1_TRA-3D_8_1.nii'
% mri_path='F:\NBRC\fMRI-MRI_Pilot_Study\Preprocessing4\HU2044\MRI';

sub_dir=char(sub_dir);
sub_code=char(sub_code);
mrs_filename=char(mrs_filename);
mri_filename=char(mri_filename);

% cd(sub_dir)

mrs_path=strcat(sub_dir,'\MRS');
mri_path=strcat(sub_dir,'\MRI');
func_mean_file={('E:\Krity\Projects\WM_GABA\Analysis\Pilot Study WM GABA_090816\HU2453_05_08_16\fMRI\meanaHU2453_PRAVAT_05_08_16_WIP_360_STRNBRG_SENSE_2_1.nii')};     % Generated after Realignment of the functional volumes during pre-processing of fMRI data
Deformation_file={('E:\Krity\Projects\WM_GABA\Analysis\Pilot Study WM GABA_090816\HU2453_05_08_16\MRI\y_rHU2453_PRAVAT_09_08_16_WIP_T1_3D_TRA_8_1.nii')};            % Generated after pre-processing of fMRI data

% Creates the name of the output mask as PCC, LFL, or LPL if the MRS filename contains 'PCC','LFL' or 'LPL' respectively.
if strfind(mrs_filename,'PCC')
    mask_name='Mask_PCC.nii';
    T1_mask_name='Mask_PCC_T1.nii';
    fidoutmask = strcat(sub_dir,'\MRS\',sub_code,'_',mask_name)             % Naming of the file which contains only the MASK (black-and-White)
    fidoutmask_T1 = strcat(sub_dir,'\MRS\',sub_code,'_',T1_mask_name)       % Naming of the file which contains T1 image and the MASK combined (Gray scale)
elseif strfind(mrs_filename,'LFL')
    mask_name='Mask_LFL.nii';
    T1_mask_name='Mask_LFL_T1.nii';
    fidoutmask = strcat(sub_dir,'\MRS\',sub_code,'_',mask_name)
    fidoutmask_T1 = strcat(sub_dir,'\MRS\',sub_code,'_',T1_mask_name)
else strfind(mrs_filename,'LPL')
    mask_name='Mask_LPL.nii';
    T1_mask_name='Mask_LPL_T1.nii';
    fidoutmask = strcat(sub_dir,'\MRS\',sub_code,'_',mask_name)
    fidoutmask_T1 = strcat(sub_dir,'\MRS\',sub_code,'_',T1_mask_name)
end

Mask_file_path={fidoutmask_T1};                                             % Path of the (Mask+T1) image file
T1img_mask_filename = strcat(sub_dir,'\MRS\w',sub_code,'_',T1_mask_name);   % Path of the normalized (Mask+T1) image file
T1img_filename = 'E:\Krity\Projects\WM_GABA\Analysis\Pilot Study WM GABA_090816\HU2453_05_08_16\MRI\wrHU2453_PRAVAT_09_08_16_WIP_T1_3D_TRA_8_1.nii';               % Path of the normalized T1 image file

%% Read Data
% Read MRS data
mrs_filename = fullfile(mrs_path,mrs_filename);                             % Creates the path name of the MRS '.spar' file
mri_filename = fullfile(mri_path,mri_filename);                             % Creates the path name of the MRI 'T1.nii' file

[N,num_vox,Tf,Fs,TR,TE,ap_offset,rl_offset,cc_offset,ap_angulation,rl_angulation,cc_angulation,vox_rl,vox_ap,rl_mrs,ap_mrs,cc_mrs, mrs_plane] = get_fid_spec(mrs_filename);  % read details from SPAR file

details_para.ap_off_mrs = ap_offset;                                        % Saving parameter details into MATLAB variables
details_para.rl_off_mrs = rl_offset;                                        % ap, rl and cc offsets of the MRS voxel are saved into the global variable details_para
details_para.cc_off_mrs = cc_offset;

details_para.rl_siz_mrs = rl_mrs;                                           % ap, rl and cc sizes of the MRS are saved into the global variable details_para
details_para.ap_siz_mrs = ap_mrs;
details_para.cc_siz_mrs = cc_mrs;

details_para.ap_ang_mrs = ap_angulation;                                    % ap, rl and cc angulations of the MRS are saved into the global variable details_para
details_para.rl_ang_mrs = rl_angulation;
details_para.cc_ang_mrs = cc_angulation;
    
status = 0;
current_pos.image_loaded = 1;

%Read MRI data
V=spm_vol(mri_filename);                                                    % Reading the 3D MRI volume using the function "spm_read_vols"
[T1,XYZ]=spm_read_vols(V);                                                  % T1 contains the 3D MRI volume and XYZ contains the matrix of coordinates constituting the T1 image 
H=spm_read_hdr(mri_filename);                                               % spm_read_hdr reads the header information of the MRI volume
details_para.mm_per_pixel = H.dime.pixdim(2:4);
pixel_per_mm_x = 1/details_para.mm_per_pixel(1);
pixel_per_mm_y = 1/details_para.mm_per_pixel(2);

details_para.ap_siz_mri = H.dime.dim(2);                                    % ap, rl and cc sizes of the MRI are saved into the global variable details_para
details_para.cc_siz_mri = H.dime.dim(4);
details_para.rl_siz_mri = H.dime.dim(3);

details_para.ap_off_mri = details_para.ap_off_mrs;                          % ap, rl and cc offsets of the MRI are saved into the global variable details_para
details_para.cc_off_mri = details_para.cc_off_mrs;
details_para.rl_off_mri = details_para.rl_off_mrs;

% get information from SPAR
ap_siz_mrs = details_para.ap_siz_mrs;
rl_siz_mrs = details_para.rl_siz_mrs;
cc_siz_mrs = details_para.cc_siz_mrs;

ap_off_mrs= details_para.ap_off_mrs;
rl_off_mrs= details_para.rl_off_mrs;
cc_off_mrs = details_para.cc_off_mrs;

ap_ang_mrs = details_para.ap_ang_mrs;
cc_ang_mrs = details_para.cc_ang_mrs;
rl_ang_mrs = details_para.rl_ang_mrs;

% Make MRI FOV equal in all dimensions
% [siz_x siz_y siz_z] = size(images);
% if (siz_z<siz_x)
%     diff_pix = round((siz_x - siz_z)/2);
%     images = padarray(images,[0, 0, diff_pix]);
% end

% find out voxel mask
% define the voxel - use x y z
% currently have spar convention that have in AUD voxel - will need to
% check for everything in future...
% x - left = positive
% y - posterior = postive
% z - superior = positive

vox_ctr = ...                                                               % Calculating the center of the MRS voxel
    [rl_siz_mrs/2 -ap_siz_mrs/2 cc_siz_mrs/2 ;
    -rl_siz_mrs/2 -ap_siz_mrs/2 cc_siz_mrs/2 ;
    -rl_siz_mrs/2 ap_siz_mrs/2 cc_siz_mrs/2 ;
    rl_siz_mrs/2 ap_siz_mrs/2 cc_siz_mrs/2 ;
    -rl_siz_mrs/2 ap_siz_mrs/2 -cc_siz_mrs/2 ;
    rl_siz_mrs/2 ap_siz_mrs/2 -cc_siz_mrs/2 ;
    rl_siz_mrs/2 -ap_siz_mrs/2 -cc_siz_mrs/2 ;
    -rl_siz_mrs/2 -ap_siz_mrs/2 -cc_siz_mrs/2 ];

% make rotations on voxel
rot_mat = rot_matrix(ap_ang_mrs,cc_ang_mrs,rl_ang_mrs);
vox_rot = rot_mat*vox_ctr.';

% calculate corner coordinates relative to xyz origin
vox_ctr_coor = [-rl_off_mrs -ap_off_mrs cc_off_mrs];
vox_ctr_coor = repmat(vox_ctr_coor.', [1,8]);
vox_corner = vox_rot+vox_ctr_coor;

% initialize mask
mask = zeros(1,size(XYZ,2));
sphere_radius = sqrt((rl_siz_mrs/2)^2+(ap_siz_mrs/2)^2+(cc_siz_mrs/2)^2);
distance2voxctr=sqrt(sum((XYZ-repmat([-rl_off_mrs -ap_off_mrs cc_off_mrs].',[1 size(XYZ, 2)])).^2,1));
sphere_mask(distance2voxctr<=sphere_radius)=1;
%sphere_mask2=ones(1,(sum(sphere_mask)));

mask(sphere_mask==1) = 1;
XYZ_sphere = XYZ(:,sphere_mask == 1);

tri = delaunayn([vox_corner.'; [-rl_off_mrs -ap_off_mrs cc_off_mrs]]);
tn = tsearchn([vox_corner.'; [-rl_off_mrs -ap_off_mrs cc_off_mrs]], tri, XYZ_sphere.');
isinside = ~isnan(tn);
mask(sphere_mask==1) = isinside;

% Reshape mask
mask = reshape(mask, size(T1));
% Mask in Raw space is created
data_value.voxel_mask=mask;                                                 % The mask is saved in the global variable data_value.voxel_mask

% data_value.XYZ = XYZ;
data_value.all_images = T1;
details_para.img_no = round(size(data_value.all_images,3)/2);
% img1 = data_value.all_images(:,:,details_para.img_no)';
img1 = data_value.all_images(end:-1:1,:,details_para.img_no)';
data_value.image = mat2gray(img1);

% Write Mask
V_mask.fname=fidoutmask;
V_mask.descrip='MRS_Voxel_Mask_Raw';
V_mask.dim=V.dim;
V_mask.dt=V.dt;
V_mask.mat=V.mat;
V_mask=spm_write_vol(V_mask,mask);

% Create T1+Mask
T1img = T1/max(T1(:));  %Dividing the T1 image by its maximum value to normalize it
T1img_mas = T1img + mask;
% T1img_mas1 = T1img_mas/max(T1img_mas(:));

T1_Mask_Raw.fname=fidoutmask_T1;
T1_Mask_Raw.descrip='T1_MRS_Voxel_Mask_Raw';
T1_Mask_Raw.dim=V.dim;
T1_Mask_Raw.dt=V.dt;
T1_Mask_Raw.mat=V.mat;
T1_Mask_Raw=spm_write_vol(T1_Mask_Raw,T1img_mas);                           % Raw mask + t1 image; Raw mask means that the coordinate system
                                                                            % of the image is in the subject's raw space. It is not standardized to the MNI template
% Saving the Normalized T1 image formed at step153
% fidoutmask_T1img = 'Mask_T1img.nii';
% T1_img.fname=fidoutmask_T1img;
% T1_img.descrip='T1_MRS_img';
% T1_img.dim=V.dim;
% T1_img.dt=V.dt;
% T1_img.mat=V.mat;
% T1_img=spm_write_vol(T1_img,T1img);



%% Preprocessing of the Mask+T1 image. i.e. Bringing the raw T1+mask to standard space by normalizng it 

matlabbatch = [];
matlabbatch{1}.spm.spatial.coreg.estwrite.ref = func_mean_file;
matlabbatch{1}.spm.spatial.coreg.estwrite.source = Mask_file_path;
matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
matlabbatch{2}.spm.spatial.normalise.write.subj.def = Deformation_file;
% matlabbatch{2}.spm.spatial.normalise.write.subj.resample(1) = Mask_file_path;
matlabbatch{2}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Coregister: Estimate & Reslice: Coregistered Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
matlabbatch{2}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{2}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
matlabbatch{2}.spm.spatial.normalise.write.woptions.interp = 4;
spm_jobman('run', matlabbatch); 

%% Extracting the mask from T1+Mask

V1=spm_vol(T1img_filename);                                                 % Reading the normalized T1 image file (HU2044_T1.nii)
[onlyT1,XYZ1]=spm_read_vols(V1);
H1=spm_read_hdr(T1img_filename);
V2=spm_vol(T1img_mask_filename);               % Reading the normalized (T1 image and the MASK combined) file (HU2044_Mask_LVC_T1.nii)
[maskT1,XYZ2]=spm_read_vols(V2);
H2=spm_read_hdr(T1img_mask_filename);

% Converting Mask+T1 into only binary Mask
maskT1(maskT1<1)=0;
maskT1(maskT1>1)=1;

% for i=1:size(maskT1,3)
%    for y=1:size(maskT1,2)
%        for z=1:size(maskT1,1)
%            if maskT1(z,y,i)<1;
%                maskT1(z,y,i)=0;
%            else
%                maskT1(z,y,i)=1;
%            end
%        end
%    end
% end

% CC = bwconncomp(maskT1);
% S = regionprops(CC,'Centroid');
% numPixels = cellfun(@numel,CC.PixelIdxList);
% [biggest,idx] = max(numPixels);
% 
% for i=1:idx
% if i== CC.PixelIdxList{idx};
% maskT1(CC.PixelIdxList{i}) = 1;
% else
% maskT1(CC.PixelIdxList{i}) = 0;
% end
% end

% onlyT1=onlyT1/max(onlyT1(:));
% mask = ((maskT1)-mat2gray(onlyT1));
% 
% for i=1:1:size(maskT1,3)
%     binary_mask(:,:,i)=im2bw(mask(:,:,i),0.05);
% end

%  
fidoutmask=strcat(sub_dir,'\MRS\','Registered_',sub_code,'_',T1_mask_name)
Mask_Registered.fname=fidoutmask;
Mask_Registered.descrip='MRS_Voxel_Mask_Registered';
Mask_Registered.dim=V1.dim;
Mask_Registered.dt=V1.dt;
Mask_Registered.mat=V1.mat;
Mask_Registered=spm_write_vol(Mask_Registered,maskT1);
end

