function results_file_folder_meg(direc1,huname)

% Prefix
%----------
key1 = 'MEG';
key2 = 'Results';

% Save mask in results directory
%-------------------------------
megdir = char(fullfile(direc1,huname,key1));
megdirresults = char(fullfile(direc1, huname, key2));
mkdir(megdirresults);

megresfile = dir(fullfile(megdir,'*.nii'));
megresfileloc = char(fullfile(megresfile.folder, megresfile.name));
copyfile(megresfileloc,megdirresults);

end