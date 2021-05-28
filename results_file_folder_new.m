function results_file_folder_new(subject_dir,subject_code,string)

regions = string;
cond = {'M'};
cond_file = {'spmT_0001'};

for sn=1:length(subject_dir)
    
    output_dir = strcat(subject_dir{sn},'\Results\',subject_code{sn});
    mkdir(fullfile(subject_dir{sn},'Results'));
    analysis_sub_dir = fullfile(subject_dir{sn},'fMRI','Analysis');
    
    spm_file.M = spm_select('FPList',analysis_sub_dir,cond_file(1),'.nii');
    
    for i=1:length(cond)
        newName = char(strcat(output_dir,'_',cond_file(i),'_',cond(i),'.nii'));
        f = char(spm_file.(cond{i}));
        copyfile(f,newName);
    end
    
    for i=1:length(regions)
        p = fullfile(subject_dir{sn}, 'MRS', regions(i));
        mask_file = char(spm_select('FPList',p,regions(i),'_mask_norm.nii'));
        if ~isempty(mask_file)
            newName = char(strcat(output_dir,'_',regions(i),'_mask_norm.nii'));
            copyfile(mask_file,newName)
        else
            fprintf('Normalized mask file for region %s not found for subject %s.\n',char(regions(i)),subject_code{sn});
        end
    end
    
end
end
