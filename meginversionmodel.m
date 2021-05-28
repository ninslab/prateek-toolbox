function meginversionmodel(workingdir)

direc = workingdir;
direc1 = strcat(direc, '/Subjects');
cont1 = dir(direc1);
num1 = length(cont1);

for i = 3:num1
    
    huname = cont1(i).name;
    megrawfiledir = fullfile(direc1 ,huname ,'MEG');
    direc2 = dir(megrawfiledir);
    megfilename = fullfile(megrawfiledir,direc2(3).name);
    mrifiledir = fullfile(direc1,huname,'MRI','MEG');
    direc3 = dir(mrifiledir);
    mrifilename = fullfile(mrifiledir, direc3(3).name);    
    megprocessinginversionmodel(mrifilename, megfilename, megrawfiledir);
    
    
end

end