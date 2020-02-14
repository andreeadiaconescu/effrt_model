function invert_reward_social(SubjectArray)

%% Specify Models and Data
pathroot   = fileparts(mfilename('fullpath')); % Change path here
savepath   = [pathroot '/inversion_results/'];     % Create a simulation directory
rp_model   = {'softmax_reward_social','softmax_reward_social_cue'};       % Specify response model
prc_model  = {'hgf_binary3l_reward_social'}; % Specify perceptual model

input_data = {'SVT_behav'};                      % Load input structure

responses =  {'narsad_table_090117_for_andreea_121517x'};

input     = input_data{1};
input_u   = load(fullfile(pathroot, [input '.txt']));

responses   = responses{1};
responses_y = load(fullfile(pathroot, [responses '.txt']));
responses_y = responses_y(1:11890,7);
nSubjects   = size(responses_y,1)./290;

if nargin < 1
    SubjectArray = 1:41;
end

ExcludedSubjects = [6 8 9 20 25 32];

for iSubject = 1 % setdiff(SubjectArray, ExcludedSubjects);
    y = responses_y([1+290*(iSubject-1):290*iSubject],1);
    est=tapas_fitModel(y,input_u,'hgf_binary3l_reward_social_config','softmax_reward_social_config');
    hgf_plotTraj_reward_social(est);
    save(fullfile([savepath, 'invertedS_', num2str(iSubject), '_', rp_model{1},prc_model{1} '.mat']), 'est','-mat');
end
end