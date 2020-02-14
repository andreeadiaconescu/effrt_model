function c = compass_choice_rate_config
% Calculates the log-probability of click-rates and choices based oon
% eefrt_task
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2020 Andreea Diaconescu KCNI


% Config structure
c = struct;

% Model name
c.model = 'Linear log-rate and choices for binary models';

% Sufficient statistics of Gaussian parameter priors
%

% Zeta_1
c.logitze1mu = logit(0.5,1);
c.logitze1sa = 1;

% Zeta_2
c.logze2mu = log(48);
c.logze2sa = 4^2;

% Gather prior settings in vectors
c.priormus = [
    c.logitze1mu, ...
    c.logze2mu, ...
         ];

c.priorsas = [
    c.logitze1sa, ...
    c.logze2sa, ...
         ];

% Model filehandle
c.obs_fun = @compass_choice_rate;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @compass_choice_rate_transp;

return;
