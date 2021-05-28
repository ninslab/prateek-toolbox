function status = read_data(file_type,path,filename)
% the function "read_data" is used to read SPAR/SDAT file from Philips
% The function returns following parameters
% FID_TD: Time-Domain signal of all(SPAR/SDAT) or selected (3DiCSI file)
% voxels
% Tf: Transmitter frequency
% Fs: Sampling Frequency
% N: Number of data samples in a signal
% Total_Vox: Total number of voxels as read from SPAR/SDAT file
% num_vox: Number of voxels selected from 3DiCSI
% pH_loc: Voxel Locations on grid which can be selected (All voxels in case of SPAR/SDAT file and selected voxel in case of 3DiCSI output)
% ap_offset, rl_offset, ap_angulation,rl_angulation: Translation and angulation offset values corresponding to ap and rl resp.
% vox_rl,vox_y: Number of voxels in rl direction and ap direction correspondingly
% rl_mrs,ap_mrs: FOV of rl and ap in MRS data


global log_file;
global details_para;
global data_value;
global details_para_org;
global temp_process_lookup;
global default_parameters;
global project_info;
global aux_stage;

status = 0;

N = [];
num_vox = [];

mrs_filename = fullfile(path,filename);
[N,num_vox,Tf,Fs,TR,TE,ap_offset,rl_offset,cc_offset,ap_angulation,rl_angulation,cc_angulation,vox_rl,vox_ap,rl_mrs,ap_mrs,cc_mrs, mrs_plane] = get_fid_spec(mrs_filename);  % read details from SPAR file
if(isempty(N) || isnan(N))
    errordlg('Error in .SPAR file');
    return;
end
[~,data_name,~] = fileparts(filename);
sdat_filename = fullfile(path,strcat(data_name,'.SDAT'));

if exist(sdat_filename,'file')
    [FID_TD] = read_2D_fid(sdat_filename,N,num_vox);  % read the data from SDAT file
else
    errordlg('SDAT file not present');
    return;
end

count = 1;
pH_loc = zeros(num_vox,2); %returns grid locations of voxels
for i = 0:vox_ap-1
    for j = 0:vox_rl-1
        pH_loc(count,:) = [i,j];
        count = count+1;
    end
end

if (file_type==1) % for metabolite file
    data_value.FID_TD_org = FID_TD; %Time domain FID data(original)
    data_value.FID_FD_org = fft(FID_TD); %Frequency domain FID data(original)-not fftshifted
    data_value.FID_FD = fftshift(data_value.FID_FD_org,1); %Frequency domain FID data(processed)-fftshifted
    data_value.FID_TD = FID_TD; %Time domain FID data(processed)
    
    % making k-space
    if (vox_ap > 1)&& (vox_rl > 1)
        data_original = zeros(vox_ap,vox_rl,N);
        count = 1;
        for i = 1:vox_ap
            for j = 1:vox_rl
                data_original(i,j,:) = data_value.FID_FD(:,count);
                count = count + 1;
            end
        end
        
        % converting spatial data to K-space
        k_space = data_original;
        for n=1:2
            k_space = fftshift(fft(k_space,[],n),n);
        end
        data_value.data_k_space_org = k_space;
        data_value.data_k_space = k_space;
    else
        data_value.data_k_space_org = 1;
        data_value.data_k_space = 1;
    end
    
    % calculate frequency and ppm
    n = 0:N-1;
    fres = (-Fs/2 + (Fs/N)*n);
    ppm = (fres)*(1E6/Tf);
    t = n/Fs;

    details_para.N = N; % No. of samples
    details_para.Fs = Fs;   %sampling frequency/spectral bandwidth.
    details_para.Tf = Tf;   %transmitter frequency
    details_para.fres = fres; %frequency values of data
    details_para.ppm = ppm; %ppm values for entire data
    details_para.t = t; %time sample values of data
 
    if strcmp(details_para.molecule, '1H')
        details_para.ref = 4.67;
        disp_ppm_seg = [0.5, 6];
    else
        details_para.ref = 0;
        disp_ppm_seg = [-18, 11];
    end
    seg(1) = convert_units(disp_ppm_seg(1),'ppm');
    seg(2) = convert_units(disp_ppm_seg(2),'ppm');
    
    details_para.disp_seg = seg; %contains the display segment start sample and end sample.
    details_para.ppm_referenced = ppm + details_para.ref; % contains ppm range after referencing
    details_para.TR = TR;
    details_para.TE = TE;
    details_para.num_vox = num_vox; %no. of voxels selected in 3DiCSI
    details_para.pH_loc = pH_loc; % contains the voxels locations in the main grid (in accordance with 3DiCSI numbering)
    details_para.selected_voxels = round(vox_rl*(vox_ap + 1)/2);
    details_para.cur_vox = round(vox_rl*(vox_ap + 1)/2);
    details_para.ap_off_mrs = ap_offset;
    details_para.rl_off_mrs  = rl_offset;
    details_para.cc_off_mrs  = cc_offset;
    details_para.ap_ang_mrs = ap_angulation;
    details_para.rl_ang_mrs = rl_angulation;
    details_para.cc_ang_mrs = cc_angulation;
    details_para.vox_rl = vox_rl;
    details_para.vox_ap = vox_ap;
    details_para.vox_cc = 1;
    details_para.rl_siz_mrs = rl_mrs;
    details_para.ap_siz_mrs= ap_mrs;
    details_para.cc_siz_mrs= cc_mrs;
    details_para.mrs_plane= mrs_plane;
    
    details_para_org = details_para;
    
    % initialize processing parameters
    temp_process_lookup = default_parameters.process_lookup;
    temp_process_lookup(6,1).para = repmat(temp_process_lookup(6,1).para, [num_vox,1]);
    temp_process_lookup(8,1).para = repmat(temp_process_lookup(8,1).para, [num_vox,1]);
    
    aux_stage.FID_TD = FID_TD;
    
    [path,filename,ext] = fileparts(mrs_filename);
    project_info.data_path = strcat(path,'\');
    project_info.mrs = strcat(filename,ext);
else
    data_value.FID_TD_ref = FID_TD;
    [path,filename,ext] = fileparts(mrs_filename);
    project_info.data_path = path;
    project_info.ref_mrs = strcat(filename,ext);
    details_para.TR_ref = TR;
    details_para.TE_ref = TE;
    details_para_org.TR_ref = TR;
    details_para_org.TE_ref = TE;
end

log_file.data_path = path;
status = 1;


