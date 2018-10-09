function output = removeNoiseIC(benitaSpecification)
%REMOVENOISEIC - Set all initial condition noise to 0 for (Benita et al., 2012) models
%
% For a (Benita et al., 2012)-style DynaSim specification, this function
% simply sets all the initial condition noise terms to 0, so that every
% simulation using this has the same starting conditions. This is useful for
% both reproducibility and debugging.
%
% Inputs:
%   'benitaSpecification': DynaSim specification structure for the (Benita
%                          et al., 2012) model
%     - see dsCheckModel and dsCheckSpecification for details
%
% Outputs:
%   'output': DynaSim specification structure for the (Benita
%             et al., 2012) model with all initial condition noise removed.
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
% Author: Austin E. Soplata <austin.soplata@gmail.com>
% Copyright (C) 2018 Austin E. Soplata, Boston University, USA

% ------------------------------------------
%% 1. Set all NoiseIC terms to 0
% ------------------------------------------
modifications  = {...
'PYdr',        'CaBufferNoiseIC'  ,  0;
'PYso',        'hANoiseIC'        ,  0;
'PYso',        'nKNoiseIC'        ,  0;
'PYso',        'mKSNoiseIC'       ,  0;
'PYso',        'hNaNoiseIC'       ,  0;
'IN',          'nKNoiseIC'        ,  0;
'IN',          'mNaNoiseIC'       ,  0;
'IN',          'hNaNoiseIC'       ,  0;
'PYdr<-PYso',  'sAMPANoiseIC'     ,  0;
'PYdr<-PYso',  'resNoiseIC'       ,  0;
'PYdr<-PYso',  'hNaNoiseIC'       ,  0;
'PYdr<-PYso',  'concNaNoiseIC'    ,  0;
'PYdr<-PYso',  'sNMDANoiseIC'     ,  0;
'PYdr<-PYso',  'xNMDANoiseIC'     ,  0;
'IN<-PYso',    'sAMPANoiseIC'     ,  0;
'IN<-PYso',    'resNoiseIC'       ,  0;
'IN<-PYso',    'sNMDANoiseIC'     ,  0;
'IN<-PYso',    'xNMDANoiseIC'     ,  0;
'IN<-PYso',    'resNoiseIC'       ,  0;
'PYso<-IN',    'sGABAANoiseIC'    ,  0;
'PYso<-IN',    'resNoiseIC'       ,  0;
'IN<-IN',      'sGABAANoiseIC'    ,  0;
'IN<-IN',      'resNoiseIC'       ,  0;
};

% ------------------------------------------
%% 2. Apply the changes to the model
% ------------------------------------------
output = dsApplyModifications(benitaSpecification, modifications);
