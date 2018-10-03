%{
# Simulation Runscript file

- Project 25:
    - Thalamocortical modeling of anesthesia for the MIT-BU P01 grant, focused
    on SWO and propofol modeling
- Direction 4:
    - Investigating (Krishnan et al., 2016) thalamic-only model, and testing
    ONLY for SWO presence in full thalamocortical model.
- Question 2:
    - Let's get our analysis measures working.
- Computational model 1:
    - Using the "dynasim-krishnan-2016-model" model/mechanism code as of git
    commit cde18eb.
- Iteration 1:
    - Simple test sims to examine the output and gimbl-vis compatibility of
    current DynaSim analysis scripts like dsCalcFR

- References:
    - Krishnan GP, Chauvette S, Shamie I, Soltani S, Timofeev I, Cash SS, et al.
    Cellular and neurochemical basis of sleep stages in the thalamocortical
    network. eLife. 2016;5: e18607.

- Note: for full explanation of what each part of these parameters and functions
do, see the runscript in the GitHub repo for this model at:

    https://github.com/asoplata/dynasim-krishnan-2016-model

Author: Austin E. Soplata <austin.soplata@gmail.com>
Copyright (C) 2018 Austin E. Soplata, Boston University, USA
%}

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BUILDING LARGE MODELS WITH MULTIPLE POPULATIONS AND CONNECTIONS
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

study_dir = strcat(mfilename);

debug = 0; % Only use 1 if cleaning
if debug == 1
    clf
    close all
    % Note: the below may be dangerous!
    if 7==exist(study_dir, 'dir')
        rmdir(study_dir, 's')
    end
end

%% Setup simulation parameters and flags
time_end = 1000;   % in milliseconds
dt =        0.01; % in milliseconds

save_data_flag = 0;
save_results_flag = 0;
verbose_flag =   1;
overwrite_flag = 1;
parfor_flag =    0;

% % local
% cluster_flag =   0;
% memory_limit =   '8G';
% num_cores =      1;

% cluster
cluster_flag =   0;
cluster_matlab_version =   '2017a';
memory_limit =   '8G';
num_cores =      1;
qsub_mode = 'loop';
% qsub_mode = 'array';
one_solve_file_flag = 0;

vary={
'Edr', 'Iapp', 3;
% 'PYdr', 'appliedStim', [0,1,2];
};

%% Setup Sparse Pyramidal-Interneuron-Network-Gamma (sPING)

% define equations of cell model (same for E and I populations)

eqns={
  'dv/dt=Iapp+@current+noise*randn(1,N_pop); Iapp=0; noise=0'
  'monitor iGABAa.functions, iAMPA.functions'
};
% Tip: monitor all functions of a mechanism using: monitor MECHANISM.functions

% create DynaSim specification structure
s=[];
s.populations(1).name='Edr';
s.populations(1).size=15;
s.populations(1).equations=eqns;
s.populations(1).mechanism_list={'iNa','iK','ileak'};
s.populations(1).parameters={'Iapp',5,'gNa',120,'gK',36,'noise',0};
s.populations(2).name='Eso';
s.populations(2).size=15;
s.populations(2).equations=eqns;
s.populations(2).mechanism_list={'iNa','iK','ileak'};
s.populations(2).parameters={'Iapp',5,'gNa',120,'gK',36,'noise',0};

s.populations(3).name='I';
s.populations(3).size=10;
s.populations(3).equations=eqns;
s.populations(3).mechanism_list={'iNa','iK'};
s.populations(3).parameters={'Iapp',0,'gNa',120,'gK',36,'noise',10};

s.connections(1).direction='I->Edr';
s.connections(1).mechanism_list={'iGABAa'};
s.connections(1).parameters={'tauD',10,'gGABAa',.1,'netcon','ones(N_pre,N_post)'}; % connectivity matrix defined using a string that evalutes to a numeric matrix
s.connections(2).direction='Eso->I';
s.connections(2).mechanism_list={'iAMPA'};
s.connections(2).parameters={'tauD',2,'gAMPA',.1,'netcon','ones(N_pre,N_post)'}; % connectivity set using a numeric matrix defined in script
s.connections(3).direction='Eso->Edr';
s.connections(3).mechanism_list={'iCOMtest'};
s.connections(4).direction='Edr->Eso';
s.connections(4).mechanism_list={'iCOMtest'};

%% Simulate Sparse Pyramidal-Interneuron-Network-Gamma (sPING)
data=dsSimulate(s,...
    'save_data_flag',save_data_flag,'study_dir',study_dir,...
    'save_results_flag',save_results_flag,...
    'vary',vary,'cluster_flag',cluster_flag,...
    'cluster_matlab_version',cluster_matlab_version,...
    'qsub_mode',qsub_mode,'one_solve_file_flag',one_solve_file_flag,...
    'verbose_flag',verbose_flag,'overwrite_flag',overwrite_flag,...
    'tspan',[0 time_end],'solver','euler','dt',dt,...
    'parfor_flag',parfor_flag,'random_seed','shuffle',...
    'memory_limit',memory_limit,'num_cores',num_cores);,...

dsPlot(data);
