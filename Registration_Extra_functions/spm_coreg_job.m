clear all; clc;
spm('Defaults','fMRI');
spm_jobman('initcfg');

error_log = cell(10,1); count = 1;
done_log = cell(10,1); countd = 1;
dirname = {'D:\GABA_monika_folder\data\Female\';...
    'D:\GABA_monika_folder\data\Male\'};
regions = {'LFC','RFC','LPC','RPC','LVC','RVC'};

for dir_n = 1
    main_dir = dirname{dir_n,1};
    f=dir(main_dir);
    names = {f(3:end,1).name};
    
%     for sn=1:size(names,2)
     for sn=1
%         subject = names{1,sn};
subject = 'HU1353';
        sub_dir = strcat(main_dir,subject,'\');
        
        for region_n=1:6
            pathname=strcat(sub_dir,regions{region_n});
            if isdir(pathname)
                T2_filter = strcat('^',subject,'_T2.*nii');
                T1_filter = strcat('^',subject,'_T1.*nii');
                T2=cellstr(spm_select('FPlist', pathname, T2_filter));
                T1=cellstr(spm_select('FPlist',pathname, T1_filter));
                delete_cnt = 1;
                delete_idx = [];
                for x=1:size(T1,1)
                    T1_name = T1{x,1};
                    [~,T1_name] = fileparts(T1_name);
                    idx = regexpi(T1_name, 'matching');
                    if ~isempty(idx)
                        delete_idx(delete_cnt) = x;
                        delete_cnt = delete_cnt + 1;
                    end
                end
                if ~isempty(delete_idx)
                    T1(delete_idx) = [];
                end
                if isempty(T2{1})||isempty(T1{1})
                    error_log(count,1) = cellstr(['No T1 T2 found in ',sub_dir,'  ',regions{region_n}]);
                    count = count + 1;
                    continue;
                end
                if size(T2,1)~=size(T1,1)
                    error_log(count,1) = cellstr(['problem in ',sub_dir,'  ',regions{region_n}]);
                    count = count + 1;
                    continue;
                end
                for n=1:size(T2,1)
                    done_log(countd,1) = cellstr(['coregistered ',sub_dir,'  ',regions{region_n}]);
                    countd = countd + 1;
                    clear matlabbatch
                    matlabbatch{1}.spm.spatial.coreg.estimate.ref = T2(n,1);
                    matlabbatch{1}.spm.spatial.coreg.estimate.source = T1(n,1);
                    matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
                    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
                    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
                    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
                    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
                    spm_jobman('run',matlabbatch);
                end
            end
        end
    end
end
% save('C:\Users\swarnalata\Documents\GUI\GUI for paper_18_12_15_seg_try\error_log.mat','error_log');
% save('C:\Users\swarnalata\Documents\GUI\GUI for paper_18_12_15_seg_try\done_log.mat','done_log');
