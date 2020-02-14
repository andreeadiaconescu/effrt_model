function [logp, yhat, res] = compass_choice_rate(r,ptrans)
% Calculates the log-probability of click-rates and choices based oon
% eefrt_task
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2020 Andreea Diaconescu KCNI
%
% Transform parameters to their native space
ze1 = tapas_sgm(ptrans(1),1);
ze2 = exp(ptrans(2));

% Weed irregular trials out from responses and inputs
u_reward = r.u(:,1);
u_reward(r.irr) = [];
u_prob = r.u(:,2);
u_prob(r.irr) = [];
y_ch = r.y(:,1);
y_ch(r.irr) = [];


% Initialize returned log-probabilities, predictions,
% and residuals as NaNs so that NaN is returned for all
% irregualar trials
n = size(y_ch,1);

% Perceived Probability (with Inflection Point), Decision Temperature
% ~~~~~~~~
mu = u_prob;
x = 2.*ze1*mu-1.*(2.*ze1-mu);
decision_noise = ze2;
    
% Calculate log-probabilities for non-irregular trials
% The reward displayed at cue phase is the reward for an hard trial; i.e.,
% choice = 1; the reward for an easy trial i.e., choice = 0 is always 1
prob = 1./(1+exp(-decision_noise.*(u_reward.*x-1.*(1-x)).*(2.*y_ch-1)));

reg = ~ismember(1:n,r.irr);
logp(reg) = log(prob);
res(reg) = (y_ch-x)./sqrt(x.*(1-x));
yhat(reg) = prob;
return;
