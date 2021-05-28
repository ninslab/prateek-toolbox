function [] = read_default_settings()
% To read the initial settings and to initialise the global variables

global log_file;
global default_parameters;
default_parameters = struct();
log_file = [];
initialise_para()  %  initialise global variables

fid = fopen('log_file.txt'); % load log file
if(fid == -1) % if log file is not present
    load_default_settings(); 
else
    identidifer = fgetl(fid); % read identitifer from log file (first line in the log file)
    if(strcmp(identidifer,'Kalpana MRS Processing Toolbox Version 1.0')) % If identifier is correct
        para_path = fgetl(fid); % second line contains name and path of the settings file
        if(ischar(para_path))  
            if(exist(para_path,'file')) % check whether the file exists
                [path1,tt1,tt2] = fileparts(para_path);
                path = strcat(path1,'\');
                flnane = strcat(tt1,tt2);
                [file_check,settings_file] = check_project_setting_file(flnane, path,2); % check and read settings file
                if(file_check == 0)
                    load_default_settings();
                else    
                    default_parameters = settings_file.default_parameters;
                    log_file.para_path = para_path;
                end
            else
                load_default_settings();
            end
        else
            load_default_settings();
        end
        
        temp_path = fgetl(fid); % third line contains project path
        if(ischar(temp_path))
            if(exist(temp_path,'dir')) % check whether the path exists
                log_file.project_path = temp_path;
            else
                log_file.project_path = pwd;
            end
        else
            log_file.project_path = pwd;
        end
        
        temp_path = fgetl(fid); % Fourth line contains data path
        if(ischar(temp_path))
            if(exist(temp_path,'dir')) % check whether the path exists
                log_file.data_path = temp_path;
            else
                log_file.data_path = pwd;
            end
        else
            log_file.data_path = pwd;
        end
        
        temp_path = fgetl(fid); % Fifth line contains saving path
        if(ischar(temp_path))
            if(exist(temp_path,'dir'))  % check whether the path exists
                log_file.saving_path = temp_path;
            else
                log_file.saving_path = pwd;
            end
        else
            log_file.saving_path = pwd;
        end
        
        temp_path = fgetl(fid); % Sixth line contains icon path
        if(ischar(temp_path))
            if(exist(temp_path,'dir'))  % check whether the path exists
                log_file.kalpana_path = temp_path;
            else
                log_file.kalpana_path = pwd;
            end
        else
            log_file.kalpana_path = pwd;
        end
       
        fclose(fid);
    else % if log file is not correct 
       load_default_settings(); 
    end
end

function [] = load_default_settings()
% sets the default values to the log_file and default_parameters

global log_file;
global default_parameters;

default_parameters.mode=0;                   % 0=Interactive; 1=Automatic
default_parameters.project_loaded = 0;
% process look-up table to maintain analysis history and to be used for
% automatic pipelines
process_names = cell({'Spatial apodization';'Spatial zerofill';'Grid shifting';'Eddy current correction';'Peak removal';'Temporal apodization';...
    'Temporal zerofill';'Phase correction';'Spectral fitting';'Absolute quantitation';'Segmentation';'Correction factors';...
    'Export results';'Mathematics'});
process_codes = [1,1; 1,2; 1,3; 2,1; 2,2; 2,3; 2,4; 2,5; 3,1; 4,1; 4,2; 5,1; 7,1; 0,0];
peaks = {-70,70;-360,-320};
prior_data = struct('No_pks',0,'phase_attrb',1,'phase_est_fix',1,'freq_table',{cell(1,7)},'amp_table',{cell(1,7)},'lineshape_table',{cell(1,12)});
t1_t2_info = struct('ref_info',[],'met_info',[]);

process_type = cell({2;[];[];[];peaks;2;1;{'zero','1st'};[1,1,2];{'Internal peak',1};[];[0,0,0,0];[];4});
process_para = cell({[];[24,24];[0,0];[];[2,25,1024];[0,0];[];[0,0];{[60,0.12,3,0.006],{prior_data;prior_data},0.5};1;[];{t1_t2_info,t1_t2_info,'Remove CSF',[1,1]};[];[]});

default_parameters.process_lookup = struct();
for i=1:size(process_names,1)
    default_parameters.process_lookup(i,1).name = process_names{i,1};
    default_parameters.process_lookup(i,1).level = process_codes(i,1);
    default_parameters.process_lookup(i,1).code = process_codes(i,2);
    default_parameters.process_lookup(i,1).type = process_type{i,1};
    default_parameters.process_lookup(i,1).para = process_para{i,1};
end

temp = pwd;
log_file.para_path = strcat(temp,'\default_settings.mat');
identifier = 'oooolaaalaaa';
save(log_file.para_path,'default_parameters','identifier');

log_file.project_path = temp;
log_file.data_path = temp;
log_file.saving_path = temp;
log_file.kalpana_path = temp;



    