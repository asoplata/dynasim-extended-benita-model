function specification = assemblemGluRKLeakSpec(numCellsScaledown)
%ASSEMBLEEXTSPEC - Construct and connect the cortex of the (Benita et al., 2012) model
%
% assembleSpecification builds a (Benita et al., 2012)-type DynaSim
% specification, including both its populations and connections from the many
% mechanism files contained in the 'models/' subdirectory.
%
% Inputs:
%   'dt': time resolution of the simulation, in ms
%   'numCellsScaledown': number to multiply each cell population size
%                        by, between 0 and 1. To run the full model, use 
%                        1. If one wishes to run a smaller model, since 
%                        the default model is rather large, use a 
%                        smaller proportion like 0.2.
%
% Outputs:
%   'specification': DynaSim specification structure for the (Benita
%                    et al., 2012) model.
%
% Dependencies:
%   - This has only been tested on MATLAB version 2017a.
%
% References:
%     - Benita, J. M., Guillamon, A., Deco, G., & Sanchez-Vives, M. V. (2012).
%     Synaptic ession and slow oscillatory activity in a biophysical
%     network model of the cerebral cortex. Frontiers in Computational
%     Neuroscience, 6. https://doi.org/10.3389/fncom.2012.00064
%
%
% Author: Austin E. Soplata <austin.soplata@gmail.com>
% Copyright (C) 2018 Austin E. Soplata, Boston University, USA

% -------------------------------------------------------------------
%% 1. Make master equations and initialize
% -------------------------------------------------------------------
% Define equations of cell model (same for all populations)
eqns={
  'dv/dt=(@current)/Cm'
  'Cm = 1'    % uF/cm^2
  'spike_threshold = -25'
  'monitor v.spikes(spike_threshold, 1)'
  'vIC = -68'    % mV
  'vNoiseIC = 50' % mV
  'v(0) = vIC+vNoiseIC*rand(1,Npop)'
};

% Initialize DynaSim specification structure
specification=[];

% -------------------------------------------------------------------
%% 2. Assemble Cortex Model and Intracortical Connections
% -------------------------------------------------------------------
% PY cells and intercompartmental PY connections:
specification.populations(1).name='PYdr';
specification.populations(1).size=round(numCellsScaledown*100);
specification.populations(1).equations=eqns;
specification.populations(1).mechanism_list={...
    'CaBuffer_PYdr_JB12',...
    'iAppliedCurrent',...
    'iHVA_PYdr_JB12',...
    'iKCa_PYdr_JB12',...
    'iNaP_PYdr_JB12',...
    'iAR_PYdr_JB12',...
    };

% Note that the soma mechanisms are somewhat sensitive to initial conditions
specification.populations(2).name='PYso';
specification.populations(2).size=round(numCellsScaledown*100);
specification.populations(2).equations=eqns;
specification.populations(2).mechanism_list={...
    'iAppliedCurrent',...
    'iLeak_PYso_JB12',...
    'iNa_PYso_JB12',...
    'iK_PYso_JB12',...
    'iA_PYso_JB12',...
    'iKS_PYso_JB12',...
    };

specification.connections(1).direction='PYso<-PYdr';
specification.connections(1).mechanism_list={...
    'iCOM_PYso_PYdr_JB12',...
    'iNaCurrs_PYso_PYdr_JB12',...
    };
specification.connections(2).direction='PYdr<-PYso';
specification.connections(2).mechanism_list={...
    'iCOM_PYdr_PYso_JB12',...
    'iAMPA_PYdr_PYso_JB12',...
    'iNMDA_PYdr_PYso_JB12'};

% IN cells and intercompartmental IN connections:
specification.populations(3).name='IN';
specification.populations(3).size=round(numCellsScaledown*20);
specification.populations(3).equations=eqns;
specification.populations(3).mechanism_list={...
    'iAppliedCurrent',...
    'iLeak_IN_JB12',...
    'iNa_IN_JB12',...
    'iK_IN_JB12',...
    };

% PY<->IN connections/synapses
specification.connections(3).direction='IN<-PYso';
specification.connections(3).mechanism_list={...
    'iAMPA_IN_PYso_JB12',...
    'iNMDA_IN_PYso_JB12'};

specification.connections(4).direction='PYso<-IN';
specification.connections(4).mechanism_list={...
    'iGABAA_PYso_IN_JB12'};

specification.connections(5).direction='IN<-IN';
specification.connections(5).mechanism_list={...
    'iGABAA_IN_IN_JB12'};

% -------------------------------------------------------------------
%% 3. Assemble Thalamic Model and Intrathalamic Connections
% -------------------------------------------------------------------

specification.populations(4).name='TC';
specification.populations(4).size=round(numCellsScaledown*20);
specification.populations(4).equations=eqns;
specification.populations(4).mechanism_list={...
    'iAppliedCurrent',...
    'iNa_TC_AS17',...
    'iK_TC_AS17',...
    'iLeak_TC_AS17',...
    'CaBuffer_TC_AS17',...
    'iT_TC_AS17',...
    'iH_TC_AS17'};

specification.populations(5).name='TRN';
specification.populations(5).size=round(numCellsScaledown*20);
specification.populations(5).equations=eqns;
specification.populations(5).mechanism_list={...
    'iAppliedCurrent',...
    'iNa_TRN_AS17',...
    'iK_TRN_AS17',...
    'iLeak_TRN_AS17',...
    'iT_TRN_AS17'};

specification.connections(6).direction='TC<-TRN';
specification.connections(6).mechanism_list={...
    'iGABAA_TC_TRN_AS17',...
    'iGABAB_TC_TRN_AS17',...
    };
specification.connections(7).direction='TRN<-TRN';
specification.connections(7).mechanism_list={'iGABAA_TRN_TRN_AS17'};
specification.connections(8).direction='TRN<-TC';
specification.connections(8).mechanism_list={'iAMPA_TRN_TC_AS17'};

% -------------------------------------------------------------------
%% 4. Thalamo-cortical Connections
% -------------------------------------------------------------------
specification.connections(9).direction='PYdr<-TC';
specification.connections(9).mechanism_list={'iAMPA_PYdr_TC'};

specification.connections(10).direction='IN<-TC';
specification.connections(10).mechanism_list={'iAMPA_IN_TC'};

specification.connections(11).direction='TC<-PYso';
specification.connections(11).mechanism_list={
    'iAMPA_TC_PYso',...
    'imGluRKLeak_TC_PYso'};

specification.connections(12).direction='TRN<-PYso';
specification.connections(12).mechanism_list={
    'iAMPA_TRN_PYso',...
    'imGluRKLeak_TRN_PYso'};
