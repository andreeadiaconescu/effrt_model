function [y_prob1,y_prob2] = simulate_sigmoid()

mu           = linspace(0.01,0.99,70);
hard_reward  = linspace(1.24,4.21,70);
easy_reward  = linspace(1,1,70);
ze1Array     = linspace(0.1,10,12);
ze2Array     = linspace(0.1,0.1,12);


lgstr1       = cell(1,size(ze1Array,1));
lgstr2       = cell(1,size(ze2Array,1));

figure;
for iBeta = 1:numel(ze1Array)% Apply the unit-square sigmoid to the inferred states
    biased_mu = (2.*ze2Array(iBeta)*mu-1.*(2.*ze2Array(iBeta)-mu));
    y_prob1 = 1./(1+exp(-ze1Array(iBeta).*biased_mu));
    y_prob2 = 1./(1+exp(-ze1Array(iBeta).*...
        (hard_reward.*biased_mu-easy_reward.*(1-biased_mu))));
    subplot(2,1,1);
    plot(mu,y_prob1);
    hold on;
    lgstr1{iBeta} = sprintf('\\zeta1 = %3.2f', ze1Array(iBeta));
    subplot(2,1,2);
    plot(hard_reward.*mu,y_prob2);
    hold on;
    lgstr2{iBeta} = sprintf('\\zeta2 = %3.2f', ze2Array(iBeta));
end
legend(lgstr1,'Location','SE');