function [y,prob] = tapas_softmax_binary_vol_sim(r, infStates, p)
% Simulates observations from a Bernoulli distribution
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

mu = infStates;
be = p(1);

mu3hat = infStates(:,3,1);



% additional decision noise injected?
if length(p)<2
    eta = 0;
else
    eta = p(2);
end

beta=exp(-mu3hat+log(be)-eta);

if size(mu,2) == 1
    if ~any(mu<0) && ~any(mu>1)
        % Apply the unit-square sigmoid to the inferred states
        prob = tapas_sgm(beta.*(2.*mu-1),1);
    else
        error('infStates incompatible with tapas_softmax_binary observation model.')
    end
else
    % Apply the unit-square sigmoid to the inferred states
    prob = tapas_sgm(beta.*(mu(:,1)-mu(:,2)),1);
end
y = binornd(1, prob);

return;
