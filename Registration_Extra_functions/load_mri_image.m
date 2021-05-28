function status = load_mri_image(path,filename)
% Loads the MRI image
% imput: initial path of the image
% laoded image is saved in global variable 'data_value.image'

global data_value;
global details_para;
global current_pos;
global info;
global details_para_org;
global project_info;

status = 0;
current_pos.image_loaded = 1;

filename = fullfile(path,filename);
info = par_read_header(filename); % Read the header in the .PAR file (not our function)
if(isempty(info))
    errordlg('error in .PAR file');
    current_pos.image_loaded = 0;
    return;
end
mri_plane = info.SliceInformation(1,1).SliceOrientation;
if details_para.multi_vox
    if (mri_plane ~= details_para.mrs_plane)
        errordlg('MRI image should be acquired in same orientation plane as MRS data');
        current_pos.image_loaded = 0;
        return;
    end
end
images = par_read_volume(info); % Read the image in the .rec file (not our function)
if(isempty(images))
    errordlg('error in .rec file');
    current_pos.image_loaded = 0;
    return;
end

details_para.SliceInformation = info.SliceInformation;
% for arbitrary orientation
switch mri_plane
    case 2
        new_img = zeros(size(images,3),size(images,1),size(images,2));
        for i=1:size(images,2)
            img1=squeeze(images(:,i,:))';
            new_img(:,:,size(images,2)-i+1)=img1;
        end
        details_para.mm_per_pixel(1) = info.Scales(3);
        details_para.mm_per_pixel(2) = info.Scales(1);
        details_para.mm_per_pixel(3) = info.Scales(2);
        ap_siz_mri = info.Fov(1);
        cc_siz_mri = info.Fov(2);
        rl_siz_mri = info.Fov(3);
        max_fov = max(ap_siz_mri,cc_siz_mri);
        ap_siz_mri = max_fov;
        cc_siz_mri = max_fov;
    case 3
        new_img = zeros(size(images,1),size(images,3),size(images,2));
        for i=1:size(images,2)
            img1=squeeze(images(:,i,:));
            new_img(:,:,size(images,2)-i+1)=img1;
        end
        new_img = images;
        details_para.mm_per_pixel = info.Scales;
        ap_siz_mri = info.Fov(1);
        cc_siz_mri = info.Fov(2);
        rl_siz_mri = info.Fov(3);
        max_fov = max(rl_siz_mri,cc_siz_mri);
        rl_siz_mri = max_fov;
        cc_siz_mri = max_fov;
    otherwise
        new_img = images;
        details_para.mm_per_pixel = info.Scales;
        ap_siz_mri = info.Fov(1);
        cc_siz_mri = info.Fov(2);
        rl_siz_mri = info.Fov(3);
        max_fov = max(ap_siz_mri,rl_siz_mri);
        ap_siz_mri = max_fov;
        rl_siz_mri = max_fov;
end
images = new_img;

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


%generate grid
ap_off_mri = info.OffCentre(1);
cc_off_mri = info.OffCentre(2);
rl_off_mri = info.OffCentre(3);
ap_ang_mri = info.Angulation(1);
cc_ang_mri = info.Angulation(2);
rl_ang_mri = info.Angulation(3);


if (details_para.vox_rl~=details_para.vox_ap)
    warndlg('The program assumes same voxel dimension in both phase-encoding and frequency-encoding directions. Hence, registration of CSI data on the MRI image might not be proper.', 'Warning');
end

pixel_per_mm_x = 1/info.Scales(1);
pixel_per_mm_y = 1/info.Scales(2);

% Make MRI image equal to MRS data
if(max_fov<ap_siz_mrs)
    dif_mm = ap_siz_mrs-max_fov;
    temp_pix_ap = round((dif_mm*pixel_per_mm_x)/2);
    images = padarray(images,[temp_pix_ap, 0, 0]);
end

if(max_fov<rl_siz_mrs)
    dif_mm = rl_siz_mrs-max_fov;
    temp_pix_rl = round((dif_mm*pixel_per_mm_y)/2);
    images = padarray(images,[0,temp_pix_rl,0]);
end

% Make MRI FOV equal in all dimensions
% [siz_x siz_y siz_z] = size(images);
% if (siz_z<siz_x)
%     diff_pix = round((siz_x - siz_z)/2);
%     images = padarray(images,[0, 0, diff_pix]);
% end
if strcmp(details_para.molecule, '1H')
    [T1_rotated, XYZ, ap_off_mri,cc_off_mri,rl_off_mri] = calculate_cords(images,ap_siz_mri,cc_siz_mri,rl_siz_mri,ap_off_mri,cc_off_mri,rl_off_mri,ap_ang_mri,cc_ang_mri,rl_ang_mri);
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
    
    mask = reshape(mask, size(T1_rotated));
    data_value.voxel_mask=mask;
else
    T1_rotated = images;
end


    
    
    % test for shift in image off-centres
ap_shift= ap_off_mrs - ap_off_mri;
rl_shift= rl_off_mrs - rl_off_mri;
cc_shift= cc_off_mrs - cc_off_mri;

if details_para.multi_vox
    if(ap_shift ~= 0)||(rl_shift ~= 0)
        y_n_str = questdlg('The MRI image is shifted from MRS data. It may belong to different subject. Do you want to continue?');
        if(~strcmp(y_n_str, 'Yes'))
            return;
        end
    end
end

T1_siz = size(T1_rotated);
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
data_value.all_images = T1_rotated;
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

details_para.ap_siz_mri = ap_siz_mri; 
details_para.cc_siz_mri = cc_siz_mri;
details_para.rl_siz_mri = rl_siz_mri;
details_para.ap_off_mri = ap_off_mri; 
details_para.cc_off_mri = cc_off_mri;
details_para.rl_off_mri = rl_off_mri;
details_para.ap_ang_mri = ap_ang_mri;
details_para.cc_ang_mri = cc_ang_mri;
details_para.rl_ang_mri = rl_ang_mri;

details_para_org = details_para;
[path,filename,ext] = fileparts(filename);
project_info.mri_path = path;
project_info.mri = strcat(filename,ext);
status = 1;




