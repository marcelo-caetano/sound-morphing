function CMMR2019_makefigsinres(time,sin,res,xmin,xmax,ymin,ymax,xlbl,ylbl,ttl,leg)

% https://www.mathworks.com/help/matlab/creating_plots/save-figure-at-specific-size-and-resolution.html
% https://www.mathworks.com/help/matlab/ref/matlab.ui.figure-properties.html
% PaperSize [width height]
% PaperPosition [left bottom width height]

% Define colors
b = [0 0 0]; %black
vdg = [0.25 0.25 0.25]; %very dark grey
dg = [0.35 0.35 0.35]; %dark grey
g = [0.5 0.5 0.5]; %grey
ht = [0.8 0.8 0.8]; % half tone
lg = [0.83 0.8 0.75]; %light grey
vlg = [0.95 0.95 0.95]; %very light grey
w = [1 1 1]; % white

% Define line widths
thinl = 1.0; %thin line
thickl = 3.0; % thick line
lwidth = 2.0; % line width
% bwidth = 0.6; % bar width

% Define font
font = 'Times New Roman';

% Set font size
textfs = 22;
legendfs = 22;
axesfs = 14;
axislblfs = 16;
titlefs = 22;

% Set marker size
markers = 6;

% Figure sizes & positions

% minimum
figsize = [15 10];
figpos = [0.5 0.5 figsize-0.5];

% Create figure
figure1 = figure('Color',w);

% pos = get(figure1,'Position');

% Set Paper Size [width height] and Paper Position [left bottom width height]
set(figure1,'PaperPositionMode','Auto','PaperUnit','centimeters','PaperSize',figsize,'PaperPosition',figpos);

% Define colormap
colormap(gray);

% Create axes
axes1 = axes('Parent',figure1);
% axes1.FontName = font;
% axes1.FontSize = axesfs;
set(axes1,'FontName',font,'FontSize',axesfs);

% Hold axes
hold(axes1,'on');
% grid(axes1,'on')

% smooth line
curve1 = plot(time,sin);
% curve1.Color = g;
% curve1.LineWidth = thinl;
set(curve1,'Color',g,'LineWidth',thinl);

% smooth line
curve2 = plot(time,res);
% curve2.Color = b;
% curve2.LineWidth = thinl;
set(curve2,'Color',b,'LineWidth',thinl);

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[xmin xmax]);
ylim(axes1, [ymin ymax]);

% Box around the axes
box(axes1,'on');

% Create legend
legend1 = legend([curve1 curve2],leg);
%legend1.Position = [0.710616984051313 0.783655221745367 0.103571428571429 0.0738095238095238];
% legend1.Orientation = 'vertical';
% legend1.FontSize = legendfs;
% legend1.FontName = font;
set(legend1,'Orientation','vertical','FontSize',legendfs,'FontName',font);

% Create ylabel
ylabel(ylbl,'FontSize',axislblfs,'FontName',font,'interpreter','latex');

% Create xlabel
xlabel(xlbl,'FontSize',axislblfs,'FontName',font);

% Create title
title1 = title(ttl);
set(title1,'FontSize',titlefs,'FontName',font);

hold(axes1,'off');

% set(figure1,'renderer','painters');
% saveas(figure1,fullfile(savpath{:}),ext);

end