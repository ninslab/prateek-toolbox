function MRS_mask_raw(subject_dir,mrs_filename,mri_filename,string)

% This code creates MRS voxel mask in the Subject�s native space.
% It picks up the voxel information from the .spar MRS file and replicates the mask on the MRS-matching T1-3D image of the subject.
% Input: list of subject directories, MRS .spar filenames, and matching MRI filenames as charater arrays
% Output: Independent masks and T1-overlapped MRS masks of subjects in native space

disp(string);

for i=1:length(mrs_filename)
    
    % Define MRS path
    if ~isempty(strfind(char(mrs_filename(i)),string))
        mrs_path(i)=fullfile(subject_dir(i),'MRS', string);
        region=string;
        
    elseif ~isempty(strfind(char(mrs_filename(i)),'LFC'))
        mrs_path(i)=fullfile(subject_dir(i),'MRS','RH');
        region='RH';
    elseif ~isempty(strfind(char(mrs_filename(i)),'LPC'))
        mrs_path(i)=fullfile(subject_dir(i),'MRS','PCC');
        region='PCC';
        %     else
        %         mrs_path=strcat(sub_dir(i),'/MRS/','Hippocampus');
        %         region='RH';
    end
    
    mri_path= fullfile(subject_dir(i),'MRI','MRS');
    mrs_filename(i)=fullfile(mrs_path(i),mrs_filename(i));
    mri_filename(i)=fullfile(mri_path,mri_filename(i));
    
    mask_raw.name=strcat(region,'_mask_raw.nii');
    mask_raw.path=fullfile(mrs_path(i),mask_raw.name);
    T1mask_raw.name=strcat(region,'_T1mask_raw.nii');
    T1mask_raw.path=fullfile(mrs_path(i),T1mask_raw.name);
    mask_norm.name=strcat(region,'_mask_norm.nii');
    mask_norm.path=fullfile(mrs_path(i),mask_norm.name);
    T1mask_norm.name=strcat(region,'_T1mask_norm.nii');
    T1mask_norm.path=fullfile(mrs_path(i),T1mask_norm.name);
    
    %Read MRS file data
    [N,num_vox,Tf,Fs,TR,TE,ap_offset,rl_offset,cc_offset,ap_angulation,rl_angulation,cc_angulation,vox_rl,vox_ap,rl_mrs,ap_mrs,cc_mrs, mrs_plane] = get_fid_spec(char(mrs_filename(i)));
    
    details_para.ap_off_mrs = ap_offset;
    details_para.rl_off_mrs = rl_offset;
    details_para.cc_off_mrs = cc_offset;
    
    details_para.rl_siz_mrs = rl_mrs;
    details_para.ap_siz_mrs = ap_mrs;
    details_para.cc_siz_mrs = cc_mrs;
    
    details_para.ap_ang_mrs = ap_angulation;
    details_para.rl_ang_mrs = rl_angulation;
    details_para.cc_ang_mrs = cc_angulation;
    
    V=spm_vol(char(mri_filename(i)));
    [T1,XYZ]=spm_read_vols(V);                                                     % T1 contains the 3D MRI volume and XYZ contains the matrix of coordinates constituting the T1 image
    H=spm_read_hdr(char(mri_filename(i)));
    details_para.mm_per_pixel = H.dime.pixdim(2:4);
    
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
    
    % initialize mask
    mask = zeros(1,size(XYZ,2));
    sphere_radius = sqrt((rl_siz_mrs/2)^2+(ap_siz_mrs/2)^2+(cc_siz_mrs/2)^2);
    distance2voxctr=sqrt(sum((XYZ-repmat([-rl_off_mrs -ap_off_mrs cc_off_mrs].',[1 size(XYZ, 2)])).^2,1));
    sphere_mask(distance2voxctr<=sphere_radius)=1;
    
    mask(sphere_mask==1) = 1;
    XYZ_sphere = XYZ(:,sphere_mask == 1);
    
    tri = delaunayn([vox_corner.'; [-rl_off_mrs -ap_off_mrs cc_off_mrs]]);
    tn = tsearchn([vox_corner.'; [-rl_off_mrs -ap_off_mrs cc_off_mrs]], tri, XYZ_sphere.');
    isinside = ~isnan(tn);
    mask(sphere_mask==1) = isinside;
    
    % Reshape mask
    mask = reshape(mask, size(T1));
    % Mask in Raw space is created
    data_value.voxel_mask=mask;
    
    data_value.all_images = T1;
    details_para.img_no = round(size(data_value.all_images,3)/2);
    img1 = data_value.all_images(end:-1:1,:,details_para.img_no)';
    data_value.image = mat2gray(img1);
    
    % Write Mask
    V_mask.fname=char(mask_raw.path);
    V_mask.descrip='MRS_Mask_Raw';
    V_mask.dim=V.dim;
    V_mask.dt=V.dt;
    V_mask.mat=V.mat;
    V_mask=spm_write_vol(V_mask,mask);
    
    % Create T1+Mask
    T1img = T1/max(T1(:));  %Dividing the T1 image by its maximum value to normalize it
    T1img_Mask = T1img + mask;
    
    T1_Mask_Raw.fname=char(T1mask_raw.path);
    T1_Mask_Raw.descrip='T1_MRS_Mask_Raw';
    T1_Mask_Raw.dim=V.dim;
    T1_Mask_Raw.dt=V.dt;
    T1_Mask_Raw.mat=V.mat;
    T1_Mask_Raw=spm_write_vol(T1_Mask_Raw,T1img_Mask);
    
end
end