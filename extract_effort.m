function extract_effort()

verbosity = 1;
extract_ze1 = false;
%% Specify Models and Data
pathroot   = fileparts(mfilename('fullpath')); % Change path here
savepath   = [pathroot '/inversion_results/']; % Create a results directory

ResponseModelParameters = {'\zeta_1',' \zeta_2'};

% load data
[~,~,txt] = xlsread(fullfile(['data/eefrt_data.xlsx']),'data');

id          = txt(2:6988,1);
nTrials     = 51;
choice      = cell2mat(txt(2:6988,8));
rate        = cell2mat(txt(2:6988,4));
reward      = cell2mat(txt(2:6988,5));
reward_prob = cell2mat(txt(2:6988,6));
cost        = cell2mat(txt(2:6988,7));

input       = [reward reward_prob cost];

responses_y = [choice rate];
nSubjects   = size(responses_y,1)./nTrials;
lgh_a = NaN(1,nSubjects);
lgstr = cell(1,nSubjects);
fh = [];
sh = [];

for iSubject = 1:nSubjects
    input_u = input([1+nTrials*(iSubject-1):nTrials*iSubject],:);
    effrt = load(fullfile([savepath, 'invertedS_', num2str(iSubject), '.mat']));
    variables_effrt{iSubject,1} = effrt.est.p_obs.ze1;
    variables_effrt{iSubject,2} = effrt.est.p_obs.ze2;
    idDisplayed                 = cell2mat(id([1+nTrials*(iSubject-1):nTrials*iSubject],1));
    variables_effrt{iSubject,3} = idDisplayed(1,1);
    states_effrt1{iSubject} = effrt.est.traj.yhat_prob1;
    states_effrt2{iSubject} = effrt.est.traj.varyhat_prob1;
end

if extract_ze1
    [B,I] = sort(cell2mat(variables_effrt(:,1)));
else
    [B,I] = sort(cell2mat(variables_effrt(:,2)));
end

variables_all                 = [cell2mat(variables_effrt(:,3)) cell2mat(variables_effrt(:,[1:2]))];
ofile=fullfile(fullfile([savepath, 'summary_MAPS', '.xlsx']));
columnNames = [{'subjectIds'},...
    {'decision_temperature','inflection_point'}];
t = array2table([num2cell(variables_all)], ...
    'VariableNames', columnNames);
writetable(t, ofile);

sorted_effrt_yhat                = states_effrt1(I);
sorted_effrt_sigmahat            = states_effrt2(I);
sorted_variables                 = variables_all(I,[2 3]);

yhat3d                        = reshape(sorted_effrt_yhat,nSubjects,1);
yhat3d                        = cell2mat(yhat3d);
reshaped_yhat3d               = reshape(yhat3d,nTrials,nSubjects);

sahat3d                        = reshape(sorted_effrt_sigmahat,nSubjects,1);
sahat3d                        = cell2mat(sahat3d);
reshaped_sahat3d               = reshape(sahat3d,nTrials,nSubjects);


if verbosity > 0
    for iSubject = 1:nSubjects
        yhat     = cell2mat(sorted_effrt_yhat(iSubject));
        sigmahat = cell2mat(sorted_effrt_sigmahat(iSubject));
        ze1      = sorted_variables(iSubject,1);
        ze2      = sorted_variables(iSubject,2);
        sorted_effrt.yhat            = yhat;
        sorted_effrt.sigmahat        = sigmahat;
        sorted_effrt.ze1             = ze1;
        sorted_effrt.ze2             = ze2;

        effrt_plot = sorted_effrt;
        colorSetting=jet(nSubjects);
        currCol = colorSetting(iSubject,:);
        [fh, sh, lgh_a(iSubject)] = plot_trajectories(iSubject,fh,sh);
        if extract_ze1
            lgstr{iSubject} = sprintf('\\zeta1 = %3.2f', effrt_plot.ze1);
        else
            lgstr{iSubject} = sprintf('\\zeta2 = %3.2f', effrt_plot.ze2);
        end
    end
legend(lgh_a,lgstr);
end


ofile1=fullfile(fullfile([savepath, 'summary_predicted_choice', '.xlsx']));
t1 = array2table(reshaped_yhat3d);
writetable(t1, ofile1);

ofile2=fullfile(fullfile([savepath, 'summary_predicted_cost', '.xlsx']));
t1 = array2table(reshaped_sahat3d);
writetable(t1, ofile2);

%% Plot MAPs
x = variables_all(:,2);
y = variables_all(:,3);

Variables = {x y};
Groups    = {1*ones(length(x), 1) 2*ones(length(y), 1)};

GroupingVariables = ResponseModelParameters;

figure;
H   = Variables;
N=numel(Variables);

colors=parula(numel(H));

for i=1:N
    e = notBoxPlot(cell2mat(H(i)),cell2mat(Groups(i)));
    set(e.data,'MarkerSize', 10);
    if i == 2 || i == 4
        set(e.data,'Marker','o');
        set(e.data,'Marker','o');
    end
    if i==1, hold on, end
    set(e.data,'Color',colors(i,:))
    set(e.sdPtch,'FaceColor',colors(i,:));
    set(e.semPtch,'FaceColor',[0.9 0.9 0.9]);
end
set(gca,'XTick',1:N)
set(gca,'XTickLabel',GroupingVariables);
hold all;
scatter([1:2]',[0.5 3.48]',100,'k','*');
set(gca,'FontName','Constantia','FontSize',20);
ylabel('MAPs of Response Model Parameters');

%% Stats
[h,p,ci,stats]=ttest(x,0.5);
disp(['Significance t-test for ze1 ' num2str(p)]);
statsZeta2.p                = p;
statsZeta2.stats            = stats.tstat;
statsZeta2.p_bonferroni     = p*6;
disp(statsZeta2);

%%
[h,p,ci,stats]=ttest(y,3.48);
disp(['Significance t-test for ze2 ' num2str(p)]);
statsBeta2.p                = p;
statsBeta2.stats            = stats.tstat;
statsBeta2.p_bonferroni     = p*6;
disp(statsBeta2);

%% Plot Trajectories
    function [fh,sh,lgh_a] = plot_trajectories(iSubject,fh,sh)
        
        if isempty(fh)
            % Set up display
            scrsz = get(0,'screenSize');
            outerpos = [0.2*scrsz(3),0.2*scrsz(4),0.8*scrsz(3),0.8*scrsz(4)];
            fh = figure(...
                'OuterPosition', outerpos,...
                'Name','Model fit results');
            
            currCol = colorSetting(iSubject,:);
            sh(1) = subplot(2,1,1);
            sh(2) = subplot(2,1,2);
        else
            figure(fh);
        end
        
        % Subplots
        axes(sh(1))
        plot(1:nTrials, effrt_plot.yhat, 'Color', currCol, 'LineWidth', 2);
        hold on;
        xlim([1 nTrials]);
        ylim([-0.2 1.2]);
        title('Predicted Probability of Hard Task Choice', 'FontWeight', 'bold');
        xlabel('Trial number');
        ylabel('p(y=1)');
        
        
        axes(sh(2));
        lgh_a = plot(1:nTrials, effrt_plot.sigmahat, 'Color', currCol, 'LineWidth', 2);
        hold on;
        xlim([1 nTrials]);
        ylim([-0.05 0.30]);
        title('Predicted Cost', 'FontWeight', 'bold');
        xlabel({'Trial number', ' '}); % A hack to get the relative subplot sizes right
        ylabel('\sigma{_y}');
    end

end