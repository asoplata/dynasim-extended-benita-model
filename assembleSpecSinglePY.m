function specification = assembleSpecSinglePY(dt, numCellsScaledown)
%ASSEMBLESPECSINGLEPY- Construct a single cell of the cortex of the (Benita et al., 2012) model
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
%     Synaptic depression and slow oscillatory activity in a biophysical
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
% specification.populations(1).size=round(numCellsScaledown*1024);
specification.populations(1).size=1;
specification.populations(1).equations=eqns;
specification.populations(1).mechanism_list={...
    'CaBuffer_PYdr_B12',...
    'iAppliedCurrent',...
    'iHVA_PYdr_B12',...
    'iKCa_PYdr_B12',...
    'iNaP_PYdr_B12',...
    'iAR_PYdr_B12',...
    };

% Note that the soma mechanisms are somewhat sensitive to initial conditions
specification.populations(2).name='PYso';
% specification.populations(2).size=round(numCellsScaledown*1024);
specification.populations(2).size=1;
specification.populations(2).equations=eqns;
specification.populations(2).mechanism_list={...
    'iAppliedCurrent',...
    'iLeak_PYso_B12',...
    'iNa_PYso_B12',...
    'iK_PYso_B12',...
    'iA_PYso_B12',...
    'iKS_PYso_B12',...
    };

specification.connections(1).direction='PYso<-PYdr';
specification.connections(1).mechanism_list={...
    'iCOM_PYso_PYdr_B12',...
    'iNaCurrs_PYso_PYdr_B12',...
    };
specification.connections(2).direction='PYdr<-PYso';
specification.connections(2).mechanism_list={...
    'iCOM_PYdr_PYso_B12',...
    };

