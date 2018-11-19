%RUNBENITAMODEL - Run the DynaSim implementation of the (Benita et al., 2012) model!
%{
This is a starter script to show both how to use the DynaSim mechanisms I've
made for simulating the (Benita et al., 2012) model in Dynasim, available
here (https://github.com/asoplata/dynasim-benita-2012-model) while also
giving you a good skeleton to start experimenting yourself.

- Install:
  1. Install DynaSim (https://github.com/DynaSim/DynaSim/wiki/Installation),
     including adding it to your MATLAB path.
  2. `git clone` or download this code's repo
     (https://github.com/asoplata/dynasim-benita-2012-model) into
     '/your/path/to/dynasim/models', i.e. the 'models' subdirectory of your
     copy of the DynaSim repo.
  3. Run this file.
  4. Believe it or not...that should be it! You should be able to start MATLAB
     in your DynaSim code directory and run this script successfully!  Let me
     know if there are problems, at austin.soplata 'at-symbol-thingy' gmail
     'dot' com

- Notes:
    - The default model is rather large, so you may wish to decrease the
      `numCellScaledownFactor` variable to decrease the size of your model.
    - Due to the complexity of the synaptic mechanisms, this REQUIRES that you
      only use EULER integration for solving the ODE system. In the future, other
      integration methods may be supported.

- Dependencies:
    - This has only been tested on MATLAB version 2017a.

- References:
    - Benita, J. M., Guillamon, A., Deco, G., & Sanchez-Vives, M. V. (2012).
    Synaptic depression and slow oscillatory activity in a biophysical
    network model of the cerebral cortex. Frontiers in Computational
    Neuroscience, 6. https://doi.org/10.3389/fncom.2012.00064

This is descended from DynaSim's `tutorial.m` script, at
https://github.com/DynaSim/DynaSim/blob/master/demos/tutorial.m

Author: Austin E. Soplata <austin.soplata@gmail.com>
Copyright (C) 2018 Austin E. Soplata, Boston University, USA
%}

% -------------------------------------------------------------------
%% 1. Define simulation parameters
% -------------------------------------------------------------------
% Setting `study_dir` to `mfilename`, which is a reserved word, will
% automatically run the simulation and deposit its data and metadata into a
% new folder in the current directory that has the SAME NAME as this file:
study_dir = mfilename;
% % If you're on a cluster and instead want to save the simulation results to a
% % folder in a different location, use the commented-out line below instead:
% study_dir = strcat('/projectnb/crc-nak/asoplata/p25-anesthesia-grant-sim-data/', mfilename);

% This is where you set the length of your simulation, in ms
time_end = 1000; % in milliseconds

% While DynaSim uses a default `dt` of 0.01 ms, we must specify ours explicitly
% since `dt` is actually used to construct our model directly.
dt = 0.01; % in milliseconds

% For the full size model (1024 PYso's and PYdr's, 256 IN), use a
% `numCellsScaledownFactor` of 1. To lower the number of cells simulated, but
% keep the same proportions, decrease this number to something > 0. As an
% example, using a numCellsScaledownFactor of 0.1 (aka using a size of 10%)
% would decrease the population sizes to 102 PYso's and PYdr's, and 26 INs.
% numCellsScaledownFactor = 1;
numCellsScaledownFactor = 0.1;

% "Vary" parameters, aka parameters to be varied -- this tells DynaSim to run a
% simulation for all combinations of values. For a tutorial on how to use
% this, see
% https://github.com/DynaSim/DynaSim/wiki/DynaSim-Getting-Started-Tutorial#running-sets-of-simulations-by-varying-model-parameters
vary={
'PYso', 'appliedStim', 0.1;
'PYdr', 'appliedStim', 0.1;
'IN',   'appliedStim', 0.1;
};

% Here is where we set simulator options specific to `dsSimulate`, which are
%   explained in the DynaSim code file `dsSimulate.m`.
save_data_flag = 0;
save_results_flag = 1;
verbose_flag =   1;
overwrite_flag = 1;
parfor_flag =    0;
% If you want to run a simulation using the batch system of your cluster, make
% sure to set the following options to something like this:
%    'cluster_flag', 1,...
%    'memory_limit', '254G',...
%    'num_cores', 16,...
cluster_flag =   0;
memory_limit =   '8G';
num_cores =      1;

% Debug: If you want to completely clean the environment and remove all data,
%   set `debug` to 1:
debug = 0;
if debug == 1
    clf
    close all
    % Note: the below may be dangerous!
    if 7==exist(study_dir, 'dir')
        rmdir(study_dir, 's')
    end
end

% -------------------------------------------------------------------
%% 2. Assemble and customize the model
% -------------------------------------------------------------------
% This builds the complete model, including all populations and connections.
spec = assembleB12Spec(dt, numCellsScaledownFactor);

% do NOT use fac values
% % This changes the behavioral state for the model between the four stages
% %   discussed in the paper: 'Awake', 'N2' (for NREM2), 'N3' (for NREM3)', and
% %   'REM'. By default, the model is set to 'Awake' conditions.
% spec = applyExperimentFactors(spec, 'N3');

% % Only run this if you do NOT want any noise/randomness in your initial
% %   conditions, which can be useful for reproducibility or debugging.
% spec = removeNoiseIC(spec);

% -------------------------------------------------------------------
%% 3. Run the simulation
% -------------------------------------------------------------------
% For an explanation of the arguments to `dsSimulate`, see the DynaSim code
%   file `dsSimulate.m`.
[data] = dsSimulate(spec,...
    'save_data_flag',save_data_flag,'study_dir',study_dir,...
    'vary',vary,'cluster_flag',cluster_flag,...
    'save_results_flag',save_results_flag,...
    'verbose_flag',verbose_flag,'overwrite_flag',overwrite_flag,...
    'tspan',[0 time_end],'solver','euler','dt',dt,...
    'parfor_flag',parfor_flag,'random_seed','shuffle',...
    'memory_limit',memory_limit,'num_cores',num_cores,...
    'plot_functions',{@dsPlot,@dsPlot,@dsPlot},...
    'plot_options',{{'plot_type','waveform','format','png'},...
                    {'plot_type','rastergram','format','png'},...
                    {'plot_type','power','xlim',[0 80]}});

% -------------------------------------------------------------------
%% 4. (Optional) Plot the results of the simulation post hoc
% -------------------------------------------------------------------
% For an explanation of the arguments to `dsSimulate`, see the DynaSim code
% If you want to run your own plotting interactively, load the data using:

% dsPlot(data);
