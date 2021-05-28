function normalizemaskproc(workingdir, getlabelval)

global common_dir_grp
global common_dir_sub

direc = workingdir;
string = {getlabelval};

common_dir_grp = direc;
common_dir_sub = strcat(common_dir_grp,'/Subjects');
f = dir(common_dir_sub);
sub_dirs = {f.name}';
subject_dir = sub_dirs(3:end);   % No. of subjects
subject_code = cellfun(@(x) x(1:6), subject_dir, 'UniformOutput', 0);                       %List of subject codes
subject_dir = cellfun(@(x) fullfile(common_dir_sub,x), subject_dir, 'UniformOutput', 0);    %List of subject directories


% Processing Raw Masks
MRS_filenames = mrs_filenames(string,direc);
filenames = MRS_filenames.(char(string));
MRS_mask_raw(subject_dir,filenames(:,1),filenames(:,2));
mrs_mask_raw=(repmat((strcat(string,'_T1mask_raw.nii')),length(subject_dir),1));
MRS_mask_normalize(subject_dir,mrs_mask_raw,filenames(:,2));

f = msgbox('Operation Completed');
end