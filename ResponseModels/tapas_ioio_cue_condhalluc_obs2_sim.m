function y = tapas_ioio_cue_condhalluc_obs2_sim(r, infStates, p)
% Simulates responses according to the condhalluc_obs model
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2016 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Get parameters
ze1 = p(1);
ze2 = p(2);
nu = p(3);

% Prediction trajectory
mu1hat = infStates(:,1,1);

% Get cue probability and true-positive rate corresponding to
% advice-outcome associations
c  = r.u(:,2);
tp = r.u(:,3);

% Update belief using precision-weighted prediction error
% with nu the generalized precision
belief = mu1hat + 1/(1 + nu)*(tp - mu1hat);
x = ze1.*belief + (1-ze1).*c;

% Decision noise
be = ze2;

% Apply the logistic sigmoid to the inferred beliefs
prob = tapas_sgm(be.*(2.*x-1),1);

% Initialize random number generator
% rng('shuffle');

% Simulate
y = binornd(1, prob);

return;
