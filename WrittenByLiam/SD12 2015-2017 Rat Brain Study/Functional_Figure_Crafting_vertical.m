%%%%%%%%%%%%%%%%%%%% Exporting Properties %%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
close all

load ModeOfData59;


[a,b]=size(ModeOfData);
Y1=(ModeOfData(1,:)-ModeOfData(2,:))'*100;
Y2=(ModeOfData(3,:)-ModeOfData(2,:))'*100;
% Y3=((ModeOfData(4,1:b)-ModeOfData(3,1:b))./ModeOfData(3,1:b))'*100;
% Y1=ModeOfData(1,1:b)'*100;
% Y2=ModeOfData(2,1:b)'*100;
% Y3=ModeOfData(3,1:b)'*100;

ATLAS=load_nii('map_Rat_Atlas59.nii');
Z1=double(ATLAS.img);Z1(Z1==0)=NaN;
Z2=double(ATLAS.img);Z2(Z2==0)=NaN;
% Z3=double(ATLAS.img);Z3(Z3==0)=NaN;
for i=1:1:b
    Z1(Z1==i)=(Y1(i,1));
    Z2(Z2==i)=(Y2(i,1));
%     Z3(Z3==i)=(Y3(i,1));
end

%%
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

%%

%%%%%%%%%%%%%%%%%%%%% FIGURE PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Graph SuperTitle
title_string='Functional Changes Compared to Baseline';
colorbar_label='Percent CBV (mode)';
figureName='Functional Fig';

% Y=[3.5,5,7,9,11];       % TRs
% X=[13,30,60,90,120]';   % TEs
% row=1;                  
% columnNumber=20;        % Column Selector

% Columns and rows
axial_slices=[ 13  25  34  42  51  61];
% axial_slices=[10 13 20 25 30 34 39 42 47 51 53 61];

[temp,n]=size(axial_slices);
m=2;
% Set Z-axis Scale
axis1=-1;
axis2=1;

factor=50;
wb1=1+factor;
we1=256-factor;
wb2=1+factor;
we2=256-factor;

% % Window Size
x__left_corner=50;
y_left_corner=50;
x_length=500;
y_length=900;

% There are Four Subplots and an Color bar
figure('Name',figureName)

hold on

count=0;
% for i=1:1:m
for j=1:1:n
    
    %         if i==1
    count=count+1;
    h=subplot(n,m,count);
    p = get(h, 'pos');
    p(3) = p(3) + 0.015;
    p(4) = p(4) + 0.015;
    set(h, 'pos', p);
    imagesc(imrotate(Z1(wb1:we1,wb2:we2,axial_slices(j)),90));
        axis image
    caxis(([axis1 axis2]));
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
    %         elseif i==2
    count=count+1;
    h=subplot(n,m,count);
    p = get(h, 'pos');
    p(3) = p(3) + 0.015;
    p(4) = p(4) + 0.015;
    set(h, 'pos', p);
    imagesc(imrotate(Z2(wb1:we1,wb2:we2,axial_slices(j)),90));
        axis image
    caxis(([axis1 axis2]));
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
    %         elseif i==3
%     count=count+1;
%     h=subplot(n,m,count);
%     p = get(h, 'pos');
%     p(3) = p(3) + 0.015;
%     p(4) = p(4) + 0.015;
%     set(h, 'pos', p);
%     imagesc(imrotate(Z3(wb1:we1,wb2:we2,axial_slices(j)),90));
%     %         end
%     axis image
%     caxis(([axis1 axis2]));
%     set(gca,'xtick',[]);
%     set(gca,'ytick',[]);
%     set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
    
end
% end
% set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
%__________________________________________________________Colorbar
colormap bipolar
hb=colorbar;
set(get(hb,'ylabel'),'String', colorbar_label,'FontSize',12,'FontWeight','bold');


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


set(hb,'Units','normalized', 'position', [0.91 0.11 0.02 0.83]);
% set(suptitle(title_string),'FontWeight','bold','FontSize',16); 
hold off
% %%
% s2=subplot(m,n,2);
% imagesc(X,Y,A15);
% caxis(([axis1 axis2]));
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% s = sprintf('15%c Flip Angle', char(176));
% title(s,'FontSize', 12);
% set(gca,'ytick',[]);
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% s3=subplot(m,n,3);
% imagesc(X,Y,A20);
% caxis(([axis1 axis2]));
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% % zliM([0 0.12]);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% s = sprintf('20%c Flip Angle', char(176));
% title(s,'FontSize', 12);
% set(gca,'ytick',[]);
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% 
% s4=subplot(m,n,4);
% imagesc(X,Y,A25);
% caxis(([axis1 axis2]));
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% % zliM([0 0.12]);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% s = sprintf('25%c Flip Angle', char(176));
% title(s,'FontSize', 12);
% set(gca,'ytick',[]);
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% %_____________________________________________________________ 2nd
% s5=subplot(m,n,5);
% imagesc(X,Y,B10);
% caxis(([axis1 axis2]));
% ylabel('50 ug/ml', 'FontName', 'Arial', 'FontSize', 12);
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% 
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% s6=subplot(m,n,6);
% imagesc(X,Y,B15);
% caxis(([axis1 axis2]));
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'ytick',[]);
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% s7=subplot(m,n,7);
% imagesc(X,Y,B20);
% caxis(([axis1 axis2]));
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% % zliM([0 0.12]);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'ytick',[]);
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% 
% s8=subplot(m,n,8);
% imagesc(X,Y,B25);
% caxis(([axis1 axis2]));
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% % zliM([0 0.12]);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'ytick',[]);
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% %_____________________________________________________________ 3rd
% s9=subplot(m,n,9);
% imagesc(X,Y,C10);
% caxis(([axis1 axis2]));
% ylabel('100 ug/ml', 'FontName', 'Arial', 'FontSize', 12);
% %%xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% 
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% s10=subplot(m,n,10);
% imagesc(X,Y,C15);
% caxis(([axis1 axis2]));
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'ytick',[]);
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% s11=subplot(m,n,11);
% imagesc(X,Y,C20);
% caxis(([axis1 axis2]));
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% % zliM([0 0.12]);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'ytick',[]);
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% 
% s12=subplot(m,n,12);
% imagesc(X,Y,C25);
% caxis(([axis1 axis2]));
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% % zliM([0 0.12]);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'ytick',[]);
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% %_____________________________________________________________ 4th
% s13=subplot(m,n,13);
% imagesc(X,Y,D10);
% caxis(([axis1 axis2]));
% ylabel('150 ug/ml', 'FontName', 'Arial', 'FontSize', 12);
% %%xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% 
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% s14=subplot(m,n,14);
% imagesc(X,Y,D15);
% caxis(([axis1 axis2]));
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'ytick',[]);
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% s15=subplot(m,n,15);
% imagesc(X,Y,D20);
% caxis(([axis1 axis2]));
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% % zliM([0 0.12]);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'ytick',[]);
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% 
% s16=subplot(m,n,16);
% imagesc(X,Y,D25);
% caxis(([axis1 axis2]));
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% % zliM([0 0.12]);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'ytick',[]);
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% %_____________________________________________________________ 5th
% s17=subplot(m,n,17);
% imagesc(X,Y,E10);
% caxis(([axis1 axis2]));
% ylabel('200 ug/ml', 'FontName', 'Arial', 'FontSize', 12);
% %%xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% 
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% s18=subplot(m,n,18);
% imagesc(X,Y,E15);
% caxis(([axis1 axis2]));
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'ytick',[]);
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% s19=subplot(m,n,19);
% imagesc(X,Y,E20);
% caxis(([axis1 axis2]));
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% % zliM([0 0.12]);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'ytick',[]);
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% 
% s20=subplot(m,n,20);
% imagesc(X,Y,E25);
% caxis(([axis1 axis2]));
% % %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% % zliM([0 0.12]);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'ytick',[]);
% set(gca,'xtick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
% %_____________________________________________________________ 6th
% s21=subplot(m,n,21);
% imagesc(X,Y,F10);
% caxis(([axis1 axis2]));
% ylabel('250 ug/ml', 'FontName', 'Arial', 'FontSize', 12);
% %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% s22=subplot(m,n,22);
% imagesc(X,Y,F15);
% caxis(([axis1 axis2]));
% %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'ytick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% s23=subplot(m,n,23);
% imagesc(X,Y,F20);
% caxis(([axis1 axis2]));
% %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% % zliM([0 0.12]);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'ytick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% % set(gca,'FontSize',8,'YTick',[1 3 5 7 9 11],'XTick',[0 30 60 90 120]);
% 
% s24=subplot(m,n,24);
% imagesc(X,Y,F25);
% caxis(([axis1 axis2]));
% %xlabel('TE (\mus)', 'FontName', 'Arial', 'FontSize', 12);
% % zliM([0 0.12]);
% ylim([3.5 11]);
% xlim([13 120]);
% set(gca,'YDir','Reverse');
% set(gca,'ytick',[]);
% set(gcf,'Position',[x__left_corner y_left_corner x_length y_length])
% 
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
