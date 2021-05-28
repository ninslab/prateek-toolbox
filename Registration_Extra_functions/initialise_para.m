function [] = initialise_para() 
% initialise global variables
global current_pos;
global details_para;
global data_value;
global globalpara;
global info_struct;
global fitted_para;
global fitted_para_ref;
global details_para_org;
global output_data;
global aux_stage;
global peak_phase;


current_pos.workspace_state = 0;      % GUI workspace states
current_pos.message = 'Start with a project';

current_pos.data_loaded = 0;
current_pos.ref_loaded = 0;
current_pos.image_loaded = 0;

current_pos.peak_selection=0;
current_pos.grid_shifting_on = 0;

current_pos.grid = 1;
current_pos.mri_plane = 1;
current_pos.iszoomed = 0;
current_pos.single_multi_select = 0;
current_pos.csi_on = 0;
current_pos.met_ref_sig = 1;
current_pos.FD_TD_display = 1;
current_pos.ppm_fres_samples_display = 1;
current_pos.ms_samples_display = 1;
current_pos.real_img_abs_display=1;
current_pos.selected_all = 0;
current_pos.mri_display = 0;           % 0 for 1 view, 1 for all 3 views together
current_pos.show_fit_sig = 1;
current_pos.show_baseline = 1;
current_pos.show_residual = 1;
current_pos.segment_img_disp_type=0;



data_value = [];
details_para = [];
details_para_org = [];
globalpara = []; 
info_struct = [];
fitted_para = [];
fitted_para_ref = [];
output_data = [];
aux_stage = [];
peak_phase = [];


