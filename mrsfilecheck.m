function mrsfilecheck

% direc = '/media/ninslab/DATA/Projects/Prateek/Prateek_New_Version/Test_Folder';
direc = '/media/ninslab/DATA/Projects/Prateek/DATA/Batch_Prateek_Test/Batch_1/';
direc1 = strcat(direc,'/Subjects');
huname = dir(direc1);
len = length(huname);
label = {'LFC'};
len1 = len - 2;
mrsfilecell = cell([len1 1]);
mrifilecell = cell([len1 1]);

for i = 3: len
    
    varhunames = huname(i).name;
    direc2 = strcat(direc1,'/',varhunames,'/MRS','/Raw');
    direc3 = strcat(direc1,'/',varhunames,'/MRI','/Raw');
    directory1 = dir(direc2); directory2 = dir(direc3);
    
    for j = 3: length(directory1)
        mrsfile = directory1(j).name;
        if contains(mrsfile, '.SPAR')
            mrsfilerelevant = mrsfile;
        else
            % Nothing
        end
    end
    mrsfilecell{i-2} = mrsfilerelevant;
    
    for j = 3:length(directory2)
        mrifile = directory2(j).name;
        if contains(mrifile, 'MRS_T1')
            mrirelevant = mrifile;
        else
            % Nothing
        end
    end
    mrifilecell{i-2} = mrirelevant;
    
    combineddatavalue = [mrsfilecell, mrifilecell];
    name = char(label);
    MRS_filenames.(name)=combineddatavalue;
    
end

end