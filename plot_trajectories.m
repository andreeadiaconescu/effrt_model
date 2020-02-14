function plot_trajectories(mu,easy_reward,hard_reward,ze1,ze2)

if nargin > 1
    mu           = linspace(0.01,0.99,70);
    hard_reward  = linspace(1.24,4.21,70);
    easy_reward  = linspace(1,1,70);
    ze1          = 0.5;
    ze2          = 3.48;
end


figure;
biased_mu = (2.*ze2*mu-1.*(2.*ze2-mu));
y_prob1 = 1./(1+exp(-ze1.*biased_mu));
y_prob2 = 1./(1+exp(-ze1.*...
    (hard_reward.*biased_mu-easy_reward.*(1-biased_mu))));
subplot(2,1,1);
plot(mu,y_prob1);
hold on;
lgstr1= sprintf('\\zeta1 = %3.2f', ze1);
subplot(2,1,2);
plot(hard_reward.*mu,y_prob2);
hold on;
lgstr2 = sprintf('\\zeta2 = %3.2f', ze2);
legend(lgstr1,'Location','SE');
legend(lgstr2,'Location','NE');