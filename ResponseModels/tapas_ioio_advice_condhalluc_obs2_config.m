function c = tapas_ioio_advice_condhalluc_obs2_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for the response model used to analyze data from conditioned
% hallucination paradigm by Powers & Corlett
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The rationale for this model is as follows:
%
% Parameter nu is a subject-specific parameter indicating the relative weight of the prior compared to the observation.
% For nu = 1, prior and observation have equal weight; 
% for nu > 1 the prior has more weight than the observation; 
% and for nu < 1 the observation has more weight than the prior
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2016 Christoph Mathys, TNU, UZH & ETHZ
% 
% modified by Andreea Diaconescu on November 22nd, 2016 for the SIBAK study.

% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Config structure
c = struct;

% Model name
c.model = 'tapas_ioio_advice_condhalluc_obs2';

% Sufficient statistics of Gaussian parameter priors

% Zeta_1
c.logitze1mu = realmax; % 
c.logitze1sa = 0;

% Zeta_2
c.logze2mu = log(48);
c.logze2sa = 1;

% Nu
c.lognumu = log(1);
c.lognusa = 1;

% Gather prior settings in vectors
c.priormus = [
    c.logitze1mu,...
    c.logze2mu,...
    c.lognumu,...
         ];

c.priorsas = [
    c.logitze1sa,...
    c.logze2sa,...
    c.lognusa,...
         ];

% Model filehandle
c.obs_fun = @tapas_ioio_condhalluc_obs2;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @tapas_ioio_condhalluc_obs2_transp;

return;
