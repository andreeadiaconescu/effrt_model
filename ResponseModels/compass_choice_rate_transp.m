function [pvec, pstruct] = compass_choice_rate_transp(r, ptrans)
% --------------------------------------------------------------------------------------------------
% Calculates the log-probability of click-rates and choices based oon
% eefrt_task
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2020 Andreea Diaconescu KCNI

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)     = tapas_sgm(ptrans(1),1);      % ze1
pstruct.ze1 = pvec(1);
pvec(2)     = exp(ptrans(2));         % ze2
pstruct.ze2 = pvec(2);


return;
