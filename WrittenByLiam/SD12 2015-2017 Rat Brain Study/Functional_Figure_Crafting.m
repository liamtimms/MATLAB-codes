%%%%%%%%%%%%%%%%%%%% Figure Crafting %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Craft from results and assign to atlas regions
load Results_SD12_59;
[temp1,b,temp2]=size(outputmatrix);
% Y1=((outputmatrix(1,1:b,1)-outputmatrix(2,1:b,1))./outputmatrix(3,1:b,1))'*100;
% Y2=((outputmatrix(3,1:b,1)-outputmatrix(2,1:b,1))./outputmatrix(3,1:b,1))'*100;
Y1=(outputmatrix(1,1:b,1)'-outputmatrix(2,1:b,1)')*100;
Y2=(outputmatrix(3,1:b,1)'-outputmatrix(2,1:b,1)')*100;

ATLAS=load_nii('map_Rat_Atlas59.nii');
Z1=double(ATLAS.img);Z1(Z1==0)=0;
Z2=double(ATLAS.img);Z2(Z2==0)=0;
for i=1:1:b-1
    
    Z1(Z1==i)=(Y1(i,1));
    Z2(Z2==i)=(Y2(i,1));
end


%% Exporting Properties 
% Run this section to set up export formating 
opts.Format= 'eps';
opts.Width = 6;
opts.Height = 8;
opts.FontSize = 1.0;
opts.color = 'RGB';
opts.FontMode = 'scaled';
opts.FontSize = 1;
% previewfig(gcf,opts);
%% 
% Run this section to get the data from the formating
get(gca)

%%
% Run this section to export the figure to an eps format (Can then be
% editted in adobe illustrator
% % % % exportfig(gcf,'SNR_adjusted_10_30_13.eps',opts);

%% load existing results
% clear
% clc
close all

M=special_load_nii('E:\Documents\Liam Timms Codi Share\SD12 Brain Study\SD12_COMPLEX_Analysis\Results_Other\AtlasNess\map_Rat_Atlas59.nii');
for i=1:1:59
   M.img(M.img==i)=ModeMean(i,1); 
end
save_nii(M,'map_Rat_Modes_CO2_59_Atlas.nii');
%%
M=special_load_nii('E:\Documents\Liam Timms Codi Share\SD12 Brain Study\SD12_COMPLEX_Analysis\Results_Other\map_Rat_Means_Anes_68_Atlas.nii');
Z1=M.img;
%%%%%%%%%%%%%%%%%%%%% FIGURE PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Graph SuperTitle
title_string='Functional Changes Compared to Baseline';
colorbar_label='Percent Change from Baseline';
figureName='Functional Fig';

% Y=[3.5,5,7,9,11];       % TRs
% X=[13,30,60,90,120]';   % TEs
% row=1;                  
% columnNumber=20;        % Column Selector

% Columns and rows
axial=1;

if axial==1
    slices=[10 13 20 25 30 34 39 42 47 51 53 61]; %used for axial
else
    slices=[113 125 149 176]; % Used for Coronal
end

[temp,n]=size(slices);


% [temp,n]=size(slices);
m=1;
% Set c-axis Scale (color)
axis1=-.18;
axis2=.18;

%  Select specfic sub-range slice
% wb="width begin", we="width end"
factor=45;
wb1=1+factor;
we1=256-factor;
wb2=1+factor;
we2=256-factor;
% Adjust the Window Size to Make it fit on your screen properly
x__left_corner=50;
y_left_corner=50;
x_length=2000;
y_length=600;

% There are Four Subplots and an Color bar
figure('Name',figureName)

hold on

count=0;
for i=1:1:m
    for j=1:1:n
        count=count+1;
        h=subplot(m,n,count);
        p = get(h, 'pos');
        p(3) = p(3) + 0.015;
        p(4) = p(4) + 0.015;
        set(h, 'pos', p);
        if axial==1
            imagesc(imrotate(Z1(wb1:we1,wb2:we2,slices(j)),90));
        else
            imagesc(imrotate(Z1(slices(j),wb1:we1,wb2:we2),90));
        end
        axis image
        caxis(([axis1 axis2]));
        set(gca,'xtick',[]);
        set(gca,'ytick',[]);
        set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
        
    end
end
% set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
%__________________________________________________________Colorbar
colormap bipolar
hb=colorbar;
set(get(hb,'ylabel'),'String', colorbar_label,'FontSize',12,'FontWeight','bold');
set(hb,'Units','normalized', 'position', [0.92 0.11 0.02 0.82]);
hold off




%------- Method for Brute force placement of figures
% [Xlocation, Relative sizeX, Relative sizeY,  ...]
% set(s1,'Units','normalized', 'position', [0.05 0.8 0.1 0.1]);
% set(s2,'Units','normalized', 'position', [0.26 0.8 0.1 0.1]);
% set(s3,'Units','normalized', 'position', [0.47 0.8 0.1 0.1]);
% set(s4,'Units','normalized', 'position', [0.68 0.8 0.1 0.1]);

% set(s1,'Units','normalized', 'position', ['' '' 0.1 0.1]);
% set(s2,'Units','normalized', 'position', ['' '' 0.1 0.1]);
% set(s3,'Units','normalized', 'position', ['' '' 0.1 0.1]);
% set(s4,'Units','normalized', 'position', ['' '' 0.1 0.1]);
% % 
% set(s5,'Units','normalized', 'position', [0.05 0.2 0.2 0.6]);
% set(s6,'Units','normalized', 'position', [0.26 0.2 0.2 0.6]);
% set(s7,'Units','normalized', 'position', [0.47 0.2 0.2 0.6]);
% set(s8,'Units','normalized', 'position', [0.68 0.2 0.2 0.6]);

% set(suptitle(title_string),'FontWeight','bold','FontSize',16); 
% 
% 
% %__________________________________________________________Colorbar
% colormap hot(100)
% hb=colorbar;
% set(get(hb,'ylabel'),'String', colorbar_label,'FontSize',12,'FontWeight','bold');
% 
% 
% %------- Method for Brute force placement of figures
% % [Xlocation, Relative sizeX, Relative sizeY,  ...]
% % set(s1,'Units','normalized', 'position', [0.05 0.8 0.1 0.1]);
% % set(s2,'Units','normalized', 'position', [0.26 0.8 0.1 0.1]);
% % set(s3,'Units','normalized', 'position', [0.47 0.8 0.1 0.1]);
% % set(s4,'Units','normalized', 'position', [0.68 0.8 0.1 0.1]);
% 
% % set(s1,'Units','normalized', 'position', ['' '' 0.1 0.1]);
% % set(s2,'Units','normalized', 'position', ['' '' 0.1 0.1]);
% % set(s3,'Units','normalized', 'position', ['' '' 0.1 0.1]);
% % set(s4,'Units','normalized', 'position', ['' '' 0.1 0.1]);
% % % 
% % set(s5,'Units','normalized', 'position', [0.05 0.2 0.2 0.6]);
% % set(s6,'Units','normalized', 'position', [0.26 0.2 0.2 0.6]);
% % set(s7,'Units','normalized', 'position', [0.47 0.2 0.2 0.6]);
% % set(s8,'Units','normalized', 'position', [0.68 0.2 0.2 0.6]);
% 
% 
% set(hb,'Units','normalized', 'position', [0.92 0.11 0.02 0.82]);
% set(suptitle(title_string),'FontWeight','bold','FontSize',16); 
% 
% % Create a uicontrol of type "text"
% %plotedit on
% annotation('textbox',[0.00700000000000006 0.450916936353828 0.14 0.063646170442282],'String',{'TR (ms)'},'FontName', 'Arial', 'FontSize', 14,'LineStyle','none','FontWeight','bold');
% annotation('textbox',[0.478000000000001 0.00425026968716133 0.14 0.063646170442282],'String',{'TE (\mus)'},'FontName', 'Arial', 'FontSize', 14,'LineStyle','none','FontWeight','bold');
% 
% %ha=tight_subplot(6, 4, [.01 .01], [.05 .1], [.05 .1]);
% 
% hold off
