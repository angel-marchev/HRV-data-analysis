function plot_compare_distfit(data1,data2, pd1, pd2, data1_name, data2_name)
%%  compare_distfit(data1,data2)
%   Creates a comparison plot, of two distribution fits, 
%   using the data that you provide as input.
% data1 - dataset 1
% data2 - dataset2
% pd1 - distribution fit for dataset 1
% pd2 - distribution fit for dataset 2

%% Force all inputs to be column vectors
data1 = data1(:);
data2 = data2(:);

%% Prepare figure
clf;
hold on;
LegHandles = []; LegText = {};


%% Plot data originally in dataset "data1"
[CdfF,CdfX] = ecdf(data1,'Function','cdf');  % compute empirical cdf
BinInfo.rule = 4;
[~,BinEdge] = internal.stats.histbins(data1,[],[],BinInfo,CdfF,CdfX);
[BinHeight,BinCenter] = ecdfhist(CdfF,CdfX,'edges',BinEdge);
hLine = bar(BinCenter,BinHeight,'hist');
set(hLine,'FaceColor','none','EdgeColor',[0.333333 0 0.666667],...
    'LineStyle','-', 'LineWidth',1);
xlabel('Data');
ylabel('Density')
LegHandles(end+1) = hLine;
LegText{end+1} = data1_name; % Use data1_name for the legend label

%% Plot data originally in dataset "data2"
[CdfF,CdfX] = ecdf(data2,'Function','cdf');  % compute empirical cdf
BinInfo.rule = 4;
[~,BinEdge] = internal.stats.histbins(data2,[],[],BinInfo,CdfF,CdfX);
[BinHeight,BinCenter] = ecdfhist(CdfF,CdfX,'edges',BinEdge);
hLine = bar(BinCenter,BinHeight,'hist');
set(hLine,'FaceColor','none','EdgeColor',[0.333333 0.666667 0],...
    'LineStyle','-', 'LineWidth',1);
xlabel('Data');
ylabel('Density')
LegHandles(end+1) = hLine;
LegText{end+1} = data2_name; % Use data2_name for the legend label

%% Create grid where function will be computed
XLim = get(gca,'XLim');
XLim = XLim + [-1 1] * 0.01 * diff(XLim);
XGrid = linspace(XLim(1),XLim(2),100);


%% Create fit "Fit 1"

% Fit this distribution to get parameter values
% To use parameter estimates from the original fit:

% pd1 = fitdist(data1, 'normal');
YPlot = pdf(pd1,XGrid);
hLine = plot(XGrid,YPlot,'Color',[1 0 0],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
LegHandles(end+1) = hLine;
LegText{end+1} = 'fit 1';

%% Create fit "Fit 2"

% Fit this distribution to get parameter values
% To use parameter estimates from the original fit:

% pd2 = fitdist(data2, 'normal');
YPlot = pdf(pd2,XGrid);
hLine = plot(XGrid,YPlot,'Color',[0 0 1],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
LegHandles(end+1) = hLine;
LegText{end+1} = 'fit 2';

%% Adjust figure
box on;
hold off;

%% Create legend from accumulated handles and labels
hLegend = legend(LegHandles,LegText,'Orientation', 'vertical', 'FontSize', 9, 'Location', 'northeast');
set(hLegend,'Interpreter','none');
end