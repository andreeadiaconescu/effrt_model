function invert_effort()

%% Specify Models and Data
pathroot   = fileparts(mfilename('fullpath')); % Change path here
savepath   = [pathroot '/inversion_results/']; % Create a results directory


% load data
[~,~,txt] = xlsread(fullfile(['data/eefrt_data.xlsx']),'data');

% Independent Variables
choice      = cell2mat(txt(2:6988,8));
rate        = cell2mat(txt(2:6988,4));
reward      = cell2mat(txt(2:6988,5));
reward_prob = cell2mat(txt(2:6988,6));
cost        = cell2mat(txt(2:6988,7));
nTrials     = 51;

input       = [reward reward_prob cost];

responses_y = [choice rate];
nSubjects   = size(responses_y,1)./nTrials;

for iSubject = 1:nSubjects
    y = responses_y([1+nTrials*(iSubject-1):nTrials*iSubject],:);
    input_u = input([1+nTrials*(iSubject-1):nTrials*iSubject],:);    
    est=compass_fitModel(y,input_u,[],'compass_choice_rate_config');
    reward_input       = input_u(:,1);
    reward_prob_input  = input_u(:,2);
    
    biased_mu = (2.*est.p_obs.ze1*reward_prob_input-1.*(2.*est.p_obs.ze1-reward_prob_input));    
    est.traj.yhat_prob1 = 1./(1+exp(-est.p_obs.ze2.*biased_mu));
    est.traj.varyhat_prob1 = est.traj.yhat_prob1.*(1-est.traj.yhat_prob1);
    
    est.traj.yhat_prob2 = 1./(1+exp(-est.p_obs.ze2.*...
        (reward_input.*biased_mu-ones(size(reward_input,1),1).*(1-biased_mu))));
    est.traj.varyhat_prob2 = est.traj.yhat_prob2.*(1-est.traj.yhat_prob2);
    save(fullfile([savepath, 'invertedS_', num2str(iSubject), '.mat']), 'est','-mat');
end
end