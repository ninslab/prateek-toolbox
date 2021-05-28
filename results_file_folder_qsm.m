function results_file_folder_qsm(workingdir)

% Prefixes
%------------------------------
key1 = 'Subjects';
key2 = '02_ProcessedEchoImages';
key3 = 'QSM';
key4 = 'Average_Echoes';
key5 = 'Avg_Echoes.nii';
key6 = 'Results';

% Saving to folders
%------------------------------
workingfiledir = fullfile(workingdir, key1);
subjectdir = dir(workingfiledir);
len = length(subjectdir);

for i = 3:len
    primarysub = subjectdir(i).name;
    qsmfile = fullfile(workingfiledir,primarysub,key3,key2,key3,key4,key5);
    resfolder = fullfile(workingfiledir, primarysub, key6);
    mkdir(resfolder);
    copyfile(char(qsmfile), char(resfolder));    
end
end