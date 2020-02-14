function [logp, yhat, res] = tapas_ioio_condhalluc_obs2(r, infStates, ptrans)
% Calculates the log-probability of response y=1 under the unit-square sigmoid model
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, TNU, UZH & ETHZ
% modified by Andreea Diaconescu for IOIO on 19/11/2017
%% Parameter nu is a subject-specific parameter indicating the relative weight of the prior compared to the observation.
% For nu = 1, prior and observation have equal weight; 
% for nu > 1 the prior has more weight than the observation; 
% and for nu < 1 the observation has more weight than the prior

% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
n = size(infStates,1);
logp = NaN(n,1);
yhat = NaN(n,1);
res  = NaN(n,1);

% Weed irregular trials out
mu1hat = infStates(:,1,1);
mu1hat(r.irr) = [];
y = r.y(:,1);
y(r.irr) = [];
c = r.u(:,2);
c(r.irr) = [];

% Social bias is ze1
% Decision temperature is a function of the decision temperature and the exponential of log-volatility
% (i.e., inverse decision temperature is exponential of negative log-volatility)
% nu is the subject-specific weighting of the prior over the true
% probability structure
ze1 = tapas_sgm(ptrans(1),1);
ze2 = exp(ptrans(2));
be = ze2;
nu = exp(ptrans(3));

% Check input format
% Check input format
if size(r.u,2) ~= 3
    error('tapas:hgf:CondHalluc:InputsIncompatible', 'Inputs incompatible with condhalluc_obs observation model. See tapas_condhalluc_obs_config.m.')
end

% Get true-positive rate corresponding to stimuli
tp = r.u(:,3);

% Update belief using precision-weighted prediction error
% with nu the generalized precision
belief = mu1hat + 1/(1 + nu)*(tp - mu1hat);
x = ze1.*belief + (1-ze1).*c;

% Calculate log-probabilities for non-irregular trials
reg = ~ismember(1:n,r.irr);
logp(reg) = -log(1+exp(-be.*(2.*x-1).*(2.*y-1)));
yhat(reg) = x;
res(reg) = (y-x)./sqrt(x.*(1-x));

return;
