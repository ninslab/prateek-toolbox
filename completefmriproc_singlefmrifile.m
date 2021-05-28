function completefmriproc_singlefmrifile(tr_value_num, slicenumbervalue_num, workingdir)

directory = workingdir;
ref_slice = slicenumbervalue_num/2;
tra = tr_value_num;

a = strcat(directory, '/Subjects/');
s = dir(a);
subject_code = s(3).name;
subject_dir = directory;

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
% results_file_folder_singlefmrifile(subject_dir, subject_code, string);

end