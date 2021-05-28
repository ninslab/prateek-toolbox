function filestructcheck(dir_value)

cd(dir_value);
    if exist('Subjects')
        dir_updated = strcat(dir_value,'/Subjects/');
        cd(dir_updated);
        
        num = length(dir(dir_updated));
        file_name = dir(dir_updated);
        
        for i = 3 : num
            filenames_val = file_name(i).name;
            if exist(filenames_val)
                str_new = strcat(dir_updated,filenames_val);
                cd(str_new);
                
                if ((exist('fMRI'))&& (exist('MRI'))&&(exist('MRS'))) == 1
                   
                    str_new_1 = strcat(str_new,'/fMRI');
                    cd(str_new_1);
                    
                    if ((exist('Analysis'))&&(exist('EPI'))&&(exist('Raw'))) == 1
                        fprintf('File Check Complete : No Errors \n');
                    else
                        fprintf('1) Analysis \n 2) EPI \n 3) Raw \n ');
                        fprintf('File Missing.......\n');
                        fprintf('Check Again.......\n');
                    end
                    
                    str_new_2 = strcat(str_new, '/MRI');
                    cd(str_new_2);
                    
                    if ((exist('fMRI'))&&(exist('MRS'))&&(exist('Raw'))) == 1
                        fprintf('File Check Complete : No Errors \n')
                    else
                        fprintf('1) fMRI \n 2) MRS \n 3) Raw \n');
                        fprintf('File Missing..........\n');
                        fprintf('Check Again.......\n');
                    end
                    
                    str_new_3 = strcat(str_new, '/MRS');
                    cd(str_new_3);
                
                    if (exist('Raw')) == 1
                        fprintf('File Check Complete : No Errors \n');
                    else
                        fprintf('Raw File Missing........\n');
                        fprintf('Check Again.........\n');
                    end
                else
                    fprintf('1) fMRI \n 2) MRI \n 3) MRS \n');
                    fprintf('File Missing.... \n');
                    fprintf('Check Again.....\n');
                end
                
                cd(dir_updated);
            else
                fprintf('File does not exist \n');
            end
        end
    else
        fprintf('Subjects : Folder does not exist');
    end


end