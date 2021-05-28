function no_vol = cal_no_vol(subject_dir,ptav, ptbv, ptcv)

vol_size = ptav*ptbv*ptcv;                      %Size of one 3D-volume
epi_dir = fullfile(subject_dir,'fMRI','EPI');
fname = cellstr(spm_select('ExtFPList',epi_dir,'^HU.*nii',1));
fname = strrep(fname{1,1},',1','');
fid = fopen(fname);                         %will open the file in binary format
binary_4D = fread(fid,inf,'int16');         %will read the binary contents of 4D-volume
no_vol = length(binary_4D)/vol_size;

end
