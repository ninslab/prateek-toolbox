function status = load_mri_image_nii(path,filename)
% Loads the MRI image
% imput: initial path of the image
% laoded image is saved in global variable 'data_value.image'

global data_value;
global details_para;
global current_pos;
global details_para_org;
global project_info;

status = 0;
current_pos.image_loaded = 1;
fidoutmask = 'Mask_LVC.nii';
fidoutmask_T1 = 'T1_Mask_LVC.nii';
filename = fullfile(path,filename)
V=spm_vol(filename);
[T1,XYZ]=spm_read_vols(V);
H=spm_read_hdr(filename);
details_para.mm_per_pixel = H.dime.pixdim(2:4);
pixel_per_mm_x = 1/details_para.mm_per_pixel(1);
pixel_per_mm_y = 1/details_para.mm_per_pixel(2);
details_para.ap_siz_mri = H.dime.dim(2); 
details_para.cc_siz_mri = H.dime.dim(4);
details_para.rl_siz_mri = H.dime.dim(3);

details_para.ap_off_mri = details_para.ap_off_mrs; 
details_para.cc_off_mri = details_para.cc_off_mrs;
details_para.rl_off_mri = details_para.rl_off_mrs;

% get information from SPAR - change later to be read in
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
vox_ctr = ...
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

mask = reshape(mask, size(T1));
data_value.voxel_mask=mask;


V_mask.fname=fidoutmask;
V_mask.descrip='MRS_Voxel_Mask';
V_mask.dim=V.dim;
V_mask.dt=V.dt;
V_mask.mat=V.mat;
V_mask=spm_write_vol(V_mask,mask);

T1img = T1/max(T1(:));
T1img_mas = T1img + .2*mask;

T1_Mask.fname=fidoutmask_T1;
T1_Mask.descrip='T1_MRS_Voxel_Mask';
T1_Mask.dim=V.dim;
T1_Mask.dt=V.dt;
T1_Mask.mat=V.mat;
T1_Mask=spm_write_vol(T1_Mask,T1img_mas);

ap_shift = 0; rl_shift = 0;
T1_siz = size(T1);
x_siz = T1_siz(2);
y_siz = T1_siz(1);
% get the left most and right most grid position
r_g = round(y_siz/2 - (rl_siz_mrs/2)*pixel_per_mm_y - rl_shift*pixel_per_mm_y);
l_g = round(y_siz/2 + (rl_siz_mrs/2)*pixel_per_mm_y - rl_shift*pixel_per_mm_y);

% get the anterior most and posterior most grid position
a_g = round(x_siz/2 - (ap_siz_mrs/2)*pixel_per_mm_x + ap_shift*pixel_per_mm_x);
p_g = round(x_siz/2 + (ap_siz_mrs/2)*pixel_per_mm_x + ap_shift*pixel_per_mm_x);

rl_g = round(linspace(r_g,l_g,details_para.vox_rl+1)); % get the right-left grid position
ap_g = round(linspace(a_g,p_g,details_para.vox_ap+1)); % get the anterior-posterior grid position


% data_value.XYZ = XYZ;
data_value.all_images = T1;
details_para.img_no = round(size(data_value.all_images,3)/2);
% img1 = data_value.all_images(:,:,details_para.img_no)';
img1 = data_value.all_images(end:-1:1,:,details_para.img_no)';
data_value.image = mat2gray(img1);

% initialize segmented image
data_value.segmented_image = uint16(data_value.all_images);
data_value.CSF_mask = uint16(data_value.all_images);
data_value.GM_mask = uint16(data_value.all_images);
data_value.WM_mask = uint16(data_value.all_images);

details_para.ap_g = ap_g;
details_para.rl_g = rl_g;
details_para.rl_lims = [r_g,l_g];
details_para.ap_lims = [a_g,p_g];

details_para_org = details_para;
[path,filename,ext] = fileparts(filename);
project_info.mri_path = path;
project_info.mri = strcat(filename,ext);
status = 1;




