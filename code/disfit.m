function [pd1,pd2,pd3,pd4] = disfit(bef_all,aft_all,b,d)
%CREATEFIT    Create plot of datasets and fits
%   [PD1,PD2,PD3,PD4] = CREATEFIT(BEF_ALL,AFT_ALL,B,D)
%   Creates a plot, similar to the plot in the main distribution fitter
%   window, using the data that you provide as input.  You can
%   apply this function to the same data you used with dfittool
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of datasets:  4
%   Number of fits:  4
%
%   See also FITDIST.

% This function was automatically generated on 30-Nov-2024 19:05:45

% Output fitted probablility distributions: PD1,PD2,PD3,PD4

% Data from dataset "bef_all data":
%    Y = bef_all

% Data from dataset "aft_all data":
%    Y = aft_all

% Data from dataset "b data":
%    Y = b

% Data from dataset "d data":
%    Y = d

% Force all inputs to be column vectors
bef_all = bef_all(:);
aft_all = aft_all(:);
b = b(:);
d = d(:);

% Prepare figure
clf;
hold on;
LegHandles = []; LegText = {};


% --- Plot data originally in dataset "bef_all data"
[CdfF,CdfX] = ecdf(bef_all,'Function','cdf');  % compute empirical cdf
BinInfo.rule = 4;
[~,BinEdge] = internal.stats.histbins(bef_all,[],[],BinInfo,CdfF,CdfX);
[BinHeight,BinCenter] = ecdfhist(CdfF,CdfX,'edges',BinEdge);
hLine = bar(BinCenter,BinHeight,'hist');
set(hLine,'FaceColor','none','EdgeColor',[0.333333 0 0.666667],...
    'LineStyle','-', 'LineWidth',1);
xlabel('Data');
ylabel('Density')
LegHandles(end+1) = hLine;
LegText{end+1} = 'bef_all data';

% --- Plot data originally in dataset "aft_all data"
[CdfF,CdfX] = ecdf(aft_all,'Function','cdf');  % compute empirical cdf
BinInfo.rule = 4;
[~,BinEdge] = internal.stats.histbins(aft_all,[],[],BinInfo,CdfF,CdfX);
[BinHeight,BinCenter] = ecdfhist(CdfF,CdfX,'edges',BinEdge);
hLine = bar(BinCenter,BinHeight,'hist');
set(hLine,'FaceColor','none','EdgeColor',[0.333333 0.666667 0],...
    'LineStyle','-', 'LineWidth',1);
xlabel('Data');
ylabel('Density')
LegHandles(end+1) = hLine;
LegText{end+1} = 'aft_all data';

% --- Plot data originally in dataset "b data"
% This dataset does not appear on the plot

% --- Plot data originally in dataset "d data"
% This dataset does not appear on the plot

% Create grid where function will be computed
XLim = get(gca,'XLim');
XLim = XLim + [-1 1] * 0.01 * diff(XLim);
XGrid = linspace(XLim(1),XLim(2),100);


% --- Create fit "fit 1"

% Fit this distribution to get parameter values
% To use parameter estimates from the original fit:
%     pd1 = ProbDistUnivParam('normal',[ 21.63415414135, 6.558177500547])
pd1 = fitdist(bef_all, 'normal');
YPlot = pdf(pd1,XGrid);
hLine = plot(XGrid,YPlot,'Color',[1 0 0],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
LegHandles(end+1) = hLine;
LegText{end+1} = 'fit 1';

% --- Create fit "fit 2"

% Fit this distribution to get parameter values
% To use parameter estimates from the original fit:
%     pd2 = ProbDistUnivParam('normal',[ 31.36989659951, 7.921557610385])
pd2 = fitdist(aft_all, 'normal');
YPlot = pdf(pd2,XGrid);
hLine = plot(XGrid,YPlot,'Color',[0 0 1],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
LegHandles(end+1) = hLine;
LegText{end+1} = 'fit 2';

% --- Create fit "fit 3"

% Fit this distribution to get parameter values
% To use parameter estimates from the original fit:
%     pd3 = ProbDistUnivParam('normal',[ 21.03752265217, 5.488646859883])
pd3 = fitdist(b, 'normal');
% This fit does not appear on the plot

% --- Create fit "fit 4"

% Fit this distribution to get parameter values
% To use parameter estimates from the original fit:
%     pd4 = ProbDistUnivParam('normal',[ 33.67828589703, 8.531136167651])
pd4 = fitdist(d, 'normal');
% This fit does not appear on the plot

% Adjust figure
box on;
hold off;

% Create legend from accumulated handles and labels
hLegend = legend(LegHandles,LegText,'Orientation', 'vertical', 'FontSize', 9, 'Location', 'northeast');
set(hLegend,'Interpreter','none');
