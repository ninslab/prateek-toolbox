function rawmrsmaskcombined(tr_value_num, slicenumbervalue_num, workingdir, getlabelval)

directory = workingdir;
ref_slice = slicenumbervalue_num/2;
tra = tr_value_num;
string = {getlabelval};
a = strcat(directory, '/Subjects/');
s = dir(a);
subject_code = s(3).name;
%subject_dir = directory;

b = strcat(a,'/',subject_code,'/fMRI', '/Raw');
g = dir(b);
filename = g(3).name;
completefmrifilename = fullfile(b,'/',filename);

filedata = niftiread(completefmrifilename);
indexsize = size(filedata);

ptav = indexsize(1); 
ptbv = indexsize(2);
ptcv = indexsize(3);

global common_dir_grp
global common_dir_sub

common_dir_grp = directory;
common_dir_sub = strcat(common_dir_grp,'/Subjects');

f = dir(common_dir_sub);
sub_dirs = {f.name}';
subject_dir = sub_dirs(3:end);   % No. of subjects

subject_code = cellfun(@(x) x(1:6), subject_dir, 'UniformOutput', 0);                       %List of subject codes
subject_dir = cellfun(@(x) fullfile(common_dir_sub,x), subject_dir, 'UniformOutput', 0);    %List of subject directories

preprocessing_SWM(subject_dir, subject_code , slicenumbervalue_num, ptav,ptbv,ptcv,tra, ref_slice);
subject_level_SWM(subject_dir, subject_code , slicenumbervalue_num, ptav,ptbv,ptcv,tra, ref_slice);
% group_level_SWM(common_dir_grp, subject_dir);
MRS_filenames = mrs_filenames(string,direc);
filenames = MRS_filenames.(char(string));
MRS_mask_raw(subject_dir,filenames(:,1),filenames(:,2));
mrs_mask_raw=(repmat((strcat(string,'_T1mask_raw.nii')),length(subject_dir),1));

f = msgbox('Operation Completed');

end