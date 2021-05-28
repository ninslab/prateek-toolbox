function MRS_filenames = mrs_filenames(string,direc)

direc1 = fullfile(direc,'Subjects');
huname = dir(direc1);
len = length(huname);
label = string;
len1 = len - 2;
mrsfilecell = cell([len1 1]);
mrifilecell = cell([len1 1]);

for i = 3: len
    
    varhunames = huname(i).name;
    direc2 = fullfile(direc1,varhunames,'MRS',char(string));
    disp(direc2);
    direc3 = fullfile(direc1,varhunames,'MRI','MRS');
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
      
        if contains(mrifile, 'T1')
            mrirelevant = mrifile;
        else
            % Nothing
        end
    end
    mrifilecell{i-2} = mrirelevant;
    
    combineddatavalue = [mrsfilecell, mrifilecell];
    name = char(label);
    
    MRS_filenames.(name)= combineddatavalue;
    
end


end