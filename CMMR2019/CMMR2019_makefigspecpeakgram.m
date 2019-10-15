function CMMR2019_makefigspecpeakgram(magspec,timefr,freqfft,tmin,tmax,freqmin,freqmax,xlbl,ylbl,ttl)
% xvector,ymatrix,errmatrix,y,t,ref,savpath
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

% https://www.mathworks.com/help/matlab/creating_plots/save-figure-at-specific-size-and-resolution.html
% https://www.mathworks.com/help/matlab/ref/matlab.ui.figure-properties.html
% PaperSize [width height]
% PaperPosition [left bottom width height]

% Define colors
b = [0 0 0]; %black
vdg = [0.25 0.25 0.25]; %very dark grey
dg = [0.35 0.35 0.35]; %dark grey
g = [0.45 0.45 0.45]; %grey
ht = [0.8 0.8 0.8]; % half tone
lg = [0.83 0.8 0.75]; %light grey
vlg = [0.95 0.95 0.95]; %very light grey
w = [1 1 1]; % white

% Define line widths
thinl = 2.5; %thin line
thickl = 3.0; % thick line
lwidth = 2.0; % line width
bwidth = 0.6; % bar width

% Define font
font = 'Times New Roman';

% Set font size
textfs = 22;
legendfs = 22;
axesfs = 14;
axislblfs = 16;
titlefs = 22;

% Set marker size
markers = 10;

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
colormap('jet');

% Create axes
axes1 = axes('Parent',figure1);
% axes1.FontName = font;
% axes1.FontSize = axesfs;
% axes1.TickLength = 0.1;
% axes1.XTickLabelRotation = xrot;
% axes1.YTickLabelRotation = yrot;
% axes1.XTick = [0 0.5 1];
% axes1.ZTick = [0 0.1 0.2];
set(axes1,'FontName',font,'FontSize',axesfs);

view(axes1,[0.5 90]);
hold(axes1,'on');
grid(axes1,'on');
axis('tight');


% Spectrogram
mesh1 = mesh(timefr,freqfft,magspec,'Parent',axes1);
% Frequency peaks of sinusoidal analysis
% mesh1.Marker = '.';
% mesh1.MarkerSize = markers;
% mesh1.LineStyle = 'none';
% mesh1.MeshStyle = 'row';
% mesh1.EdgeColor = b;
% mesh1.LineWidth = lwidth;
set(mesh1,'Marker','.','MarkerSize',markers,'LineStyle','none','MeshStyle','row');

% Spectral peaks
% plot1 = plot(timefr,freqpeak,'.','Color',b,'MarkerSize',markers,'Parent',axes1);
% plot1.Marker = '.';
% plot1.Color = b;
% plot1.MarkerSize = markers;
% plot1.LineStyle = 'none';


% Limits to display
xlim(axes1,[tmin tmax]);
ylim(axes1, [freqmin freqmax]);

% Create xlabel
xlabel(xlbl,'FontSize',axesfs,'FontName',font);

% Create ylabel
ylabel(ylbl,'FontSize',axesfs,'FontName',font);

% Create title
title(ttl,'FontSize',titlefs,'FontName',font);

hold(axes1,'off');

% set(figure1,'renderer','painters');
% saveas(figure1,fullfile(savpath{:}),ext);

end