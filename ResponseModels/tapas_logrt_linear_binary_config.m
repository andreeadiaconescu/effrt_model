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
c.logze2mu = log(48);
c.logze2sa = 4^2;

% Zeta_2
c.logze1mu = log(log(10));
c.logze1sa = log(2);

% Beta_0
c.be0mu = log(500); 
c.be0sa = 4;

% Beta_1
c.be1mu = 0;
c.be1sa = 4;

% Beta_2
c.be2mu = 0; 
c.be2sa = 4;

% Beta_3
c.be3mu = 0; 
c.be3sa = 4;

% Gather prior settings in vectors
c.priormus = [
    c.logze1mu, ...
    c.logze2mu, ...
    c.be0mu,...
    c.be1mu,...
    c.be2mu,...
    c.be3mu,...
         ];

c.priorsas = [
    c.logze1sa, ...
    c.logze2sa, ...
    c.be0sa,...
    c.be1sa,...
    c.be2sa,...
    c.be3sa,...
         ];

% Model filehandle
c.obs_fun = @compass_choice_rate;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @tapas_logrt_linear_binary_transp;

return;
