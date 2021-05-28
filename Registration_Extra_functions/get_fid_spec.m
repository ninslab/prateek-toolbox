function [N,Total_Vox,Tf,Fs,TE,TR,ap_offset,rl_offset,cc_offset,ap_angulation,rl_angulation,cc_angulation,vox_rl,vox_ap,fov_rl,fov_ap,fov_cc,mrs_plane] = get_fid_spec(spar_filename)
global details_para;
global error_types;

fid=fopen(spar_filename);
if(fid<0)
    fprintf('could not open file %s\n',spar_filename);
    error_types.data_loading = 1;
    return
end

while(1)
    str = fgetl(fid); % to read a line in the file
    loc = strfind(str,'dataformat:');
    if(~isempty(loc))
        s=find(str=='(',1,'first');
        type=str(s+13:end-1);
        break
    end
end

if (strcmp(type,'VAX CPX floats')~=1)
    N = [];
    Total_Vox = [];
    Tf = [];
    Fs = [];
    ap_offset=[];
    rl_offset=[];
    ap_angulation= [];
    rl_angulation=[];
    cc_angulation = [];
    vox_rl=[];
    vox_ap=[];
    fov_ap=[];
    fov_rl=[];
    warndlg('The loaded .SPAR file seems to be different from standard format. Consider re-checking.');
    return;
end

while(true)
    str=fgetl(fid);
    if ~ischar(str), break, end
    if(isempty(str)), continue, end
    
    [type data]=General_Information_Line(str);
    switch(type)
        case 'samples'
            N=sscanf(data, '%d')';
        case 'rows'
            Total_Vox=sscanf(data, '%d')';
        case 'synthesizer_frequency'
            Tf=sscanf(data, '%f')';
        case 'sample_frequency'
            Fs=sscanf(data, '%d')';
        case 'nucleus'
            details_para.molecule=data;
        case 'echo_time'
            TE=sscanf(data, '%f')';
        case 'repetition_time'
            TR=sscanf(data, '%f')';
        case 'ap_size'
            ap_size=sscanf(data, '%d')';
        case 'lr_size'
            lr_size=sscanf(data, '%d')';
        case 'cc_size'
            cc_size=sscanf(data, '%d')';
        case 'ap_off_center'
            ap_offset_sv=sscanf(data, '%f')';
            ap_offset_sv= round(ap_offset_sv*1000)/1000;
        case 'lr_off_center'
            rl_offset_sv=sscanf(data, '%f')';
            rl_offset_sv = round(rl_offset_sv*1000)/1000; 
        case 'cc_off_center'
            cc_offset_sv=sscanf(data, '%f')';
            cc_offset_sv = round(cc_offset_sv*1000)/1000;
        case 'ap_angulation'
            ap_angulation_sv=sscanf(data, '%f')';
            ap_angulation_sv = round(ap_angulation_sv*1000)/1000;
        case 'lr_angulation'
            rl_angulation_sv=sscanf(data, '%f')';
            rl_angulation_sv = round(rl_angulation_sv*1000)/1000;
        case 'cc_angulation'
            cc_angulation_sv=sscanf(data, '%f')';
            cc_angulation_sv = round(cc_angulation_sv*1000)/1000;
        case 'si_ap_off_center'
            ap_offset=sscanf(data, '%f')';
            ap_offset = round(ap_offset*1000)/1000;
        case 'si_lr_off_center'
            rl_offset=sscanf(data, '%f')';
            rl_offset = round(rl_offset*1000)/1000;
        case 'si_cc_off_center'
            cc_offset=sscanf(data, '%f')';
            cc_offset = round(cc_offset*1000)/1000; 
        case 'si_ap_off_angulation'
            ap_angulation=sscanf(data, '%f')';
            ap_angulation = round(ap_angulation*1000)/1000;
        case 'si_lr_off_angulation'
            rl_angulation=sscanf(data, '%f')';
            rl_angulation = round(rl_angulation*1000)/1000;
        case 'si_cc_off_angulation'
            cc_angulation=sscanf(data, '%f')';
            cc_angulation = round(cc_angulation*1000)/1000;
        case 'phase_encoding_enable'
            phase_encoding_enable=data;
        case 'nr_of_phase_encoding_profiles_ky'
            phase_encoding_profile=sscanf(data, '%f')';
        case 'nr_of_phase_encoding_profiles_kx'
            phase_encoding_profile=sscanf(data, '%f')';
        case 'phase_encoding_direction'
            acquisition_plane=data;
        case 'phase_encoding_fov'
            phase_encoding_fov=sscanf(data, '%f')';
        case 'dim2_pnts'
            vox_rl=sscanf(data, '%f')';
        case 'dim3_pnts'
            vox_ap=sscanf(data, '%f')';
        case 'cc_off_center'
            cc_offset_sv=sscanf(data, '%f')';

        otherwise
            continue;
    end
end


% to calculate FOV of MRS
if (strcmp(phase_encoding_enable,'yes'))
    details_para.multi_vox = 1;                 % SV = 0; MV = 1
    if (phase_encoding_profile == vox_ap)
        fov_rl= phase_encoding_fov;
        fov_ap= round((fov_rl/vox_rl)*vox_ap);
    elseif (phase_encoding_profile == vox_rl)
        fov_ap= phase_encoding_fov;
        fov_rl= round((fov_ap/vox_ap)*vox_rl);
    end
    
    if(strcmp(acquisition_plane, 'trans'))
        mrs_plane = 1;
    elseif (strcmp(acquisition_plane, 'sag'))
        mrs_plane = 2;
    elseif (strcmp(acquisition_plane, 'cor'))
        mrs_plane = 3;
    else
        mrs_plane = 1;
    end
else
    details_para.multi_vox = 0;
    fov_rl = lr_size;
    fov_ap = ap_size;
    mrs_plane = 1;
    ap_offset = ap_offset_sv;
    rl_offset = rl_offset_sv;
    cc_offset = cc_offset_sv;
    ap_angulation = ap_angulation_sv;
    rl_angulation = rl_angulation_sv;
    cc_angulation = cc_angulation_sv;
end
    fov_cc = cc_size;

fclose(fid);


function [type data]=General_Information_Line(str)
s=find(str==':',1,'first');
if(isempty(s)), s=length(str); end
type=str(1:s-2);  data=str(s+1:end);
while(~isempty(data)&&(strcmp(data(1),' '))), data=data(2:end); end
while(~isempty(data)&&data(end)==' '), data=data(1:end-1); end
tmp = find(data=='"');
if (~isempty(tmp))
    data = data(tmp(1)+1:tmp(2)-1);
end
    
    
    
    