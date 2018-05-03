% % % % % % % %  SD12 Master Controller   % % % % % % %
% % % % % % % %    Liam Timms 8/24/16    % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

% adapted from CAG_Code_v7_LT and Functional_postCAG_LT_Data_Analysis_v2 as
% they were refactored
%% Clean workspace
clear
clc
close all

%% load old data structure
% load('myDataRaw_SD12_174.mat')

%% or construct the data structure
% [myDataRaw] = get_myDataRaw(3, 12, 174);

%%
[myData_Intensity] = get_myDataRaw_Intensity_v2(5, 12, 174);
%%

myDataRaw=myData_Intensity.Raw;
myDataIndex=myData_Intensity.Xindex;

%% Insert circuit formation here

[myDataRaw] =get_CircuitsGrouped(myDataRaw, Circuit1);
[myDataRaw] =get_CircuitsGrouped(myDataRaw, Circuit2);
[myDataRaw] =get_CircuitsGrouped(myDataRaw, Circuit3);
[myDataRaw] =get_CircuitsGrouped(myDataRaw, Circuit5);
[myDataRaw] =get_CircuitsGrouped(myDataRaw, Circuit4);


%% set parameters for for-loops based on size
% delete animal 11
myDataRaw(:,7,:)=[];

% For intensity we also want to delete the first two scans
% myDataRaw(1,:,:)=[];
% myDataRaw(1,:,:)=[];

myDataIndex(:,7,:)=[];

% For intensity we also want to delete the first two scans
% myDataIndex(1,:,:)=[];
% myDataIndex(1,:,:)=[];

%%
[a b c]=size(myDataRaw)

%% Histogram Analysis and Individual Animal Processing
% binsize=0.005; %initially we used .001 for calculating the data and .01 for displaying the histograms
binsize=.01;
filtsize=3; %currently the filtered versions are not used
plotControl=1; %set to 1 to create more plots along the way

[myDataRawSmushed, myDataHist, myDataHistSmushed, myDataHistNorm, myDataHistNormSmushed, myDataHistSmooth, myDataHistSmoothSmushed] =get_HistogramsFromMyDataRaw(myDataRaw, binsize, filtsize, plotControl);

%%

% [MeanVals, MedianVals, ModeVals, SkewVals, KurtosisVals, TMeanVals, RMSVals, RSqrOfTotalGaussian, RSqrOfModeGaussian, FitInfo, ProblemRegions, WindowHistFit, FullHistFit, Res] =get_DistributionCharacterizationSD12_v4(myDataRaw,myDataHist);
[MeanVals_Intensity, MedianVals, MMDiffVals, RMSVals, ProblemRegions] =get_DistributionCharacterizationSD12_v5(myDataRaw);

%% CBV Calculation

[MeanVals_CBV] =get_RegionalCBV_alternateWay(MeanVals_Intensity, BloodValues);

%%

MeanVals_CBV(1,:,:)=[];

[a b c]=size(MeanVals_CBV)

%%
% State and Functional Analysis
NumStates=a;
NumAn=b;
NumReg=c;
alpha=0.05;
% s=sprintf('%d',NumReg-1);

[MeanMean, MeanStd, Mean_Diff, Mean_Diff_Mean, Mean_Diff_Std, Mean_Diff_Ttest, Mean_Diff_pVal, Mean_Diff_2StdTest] =get_SD12_Functional_Animal_Analysis_v2(MeanVals_CBV, alpha, NumStates, NumAn, NumReg);
% [MedianMean, MedianStd, Median_Diff, Median_Diff_Mean, Median_Diff_Std, Median_Diff_Ttest, Median_Diff_pVal, Median_Diff_2StdTest] =get_SD12_Functional_Animal_Analysis_v2(MedianVals, alpha, NumStates, NumAn, NumReg);
% [RMSMean, RMSStd, RMS_Diff, RMS_Diff_Mean, RMS_Diff_Std, RMS_Diff_Ttest, RMS_Diff_pVal, RMS_Diff_2StdTest] =get_SD12_Functional_Animal_Analysis_v2(RMSVals, alpha, NumStates, NumAn, NumReg);
% [MMDiffMean, MMDiffStd, MMDiff_Diff, MMDiff_Diff_Mean, MMDiff_Diff_Std, MMDiff_Diff_Ttest, MMDiff_Diff_pVal, MMDiff_Diff_2StdTest] =get_SD12_Functional_Animal_Analysis_v2(MMDiffVals, alpha, NumStates, NumAn, NumReg);

%% Segmentation
%on a regional basis
numberOfClusters=2;
[myDataSeg] =get_SegmentationSD12(myDataRaw, numberOfClusters);


%% Atlas With Values Crafting

% Craig Figure Slices:
% Axial_slices=[10 13 20 25 30 34 39 42 47 51 53 61]; %used for axial
% Coronal_slices=[113 125 149 176]; % Used for Coronal

% Axial_slices=[9 15 21 27 33 39 45 51 57 63]; %used for axial
% Coronal_slices=[114 128 142 156 180]; % Used for Coronal
% s=sprintf('%d',NumReg-1);

s=sprintf('%d',174);
loadname=strcat('map_Rat_Atlas_', s, '_REGION.nii');
AtlasNii=special_load_nii(loadname);
AtlasImg=double(AtlasNii.img);
%Axial_slices =get_Slices(AtlasImg, 'axial', 10, 5);
Coronal_slices =get_Slices(AtlasImg, 'coronal', 6, 15);
Coronal_slices(6)=[];
% Sagittal_slices =get_Slices(AtlasImg, 'sagittal', 5, 5);

PlotControl=0;

folder1='AtlasesOfFinalPush';
folder2='figure_Matrices';

valueType='RawAtlas';
for k=1:1:2
    if k==1
        layout='vertical';
    elseif k==2
        layout='horizontal';
    end
    
    CurrentImg=AtlasImg;
    [FigureMatrixAxial] =get_AtlasFigure_v3(CurrentImg, Axial_slices, 'axial', layout);
    [FigureMatrixCoronal] =get_AtlasFigure_v3(CurrentImg, Coronal_slices, 'coronal', layout);
    
    if PlotControl==1
        figure
        imagesc(FigureMatrixAxial)
        figure
        imagesc(FigureMatrixCoronal)
    end
    
    saveName=strcat(folder2, '/Rat_', valueType, '_', s, '_Atlas_Matrix_Axial_',layout,'.mat');
    save(saveName,'FigureMatrixAxial')
    saveName=strcat(folder2, '/Rat_', valueType, '_', s, '_Atlas_Matrix_Coronal_',layout,'.mat');
    save(saveName,'FigureMatrixCoronal')
    
end
%% Make Nii's with the regional values all plotted onto it and make 2D matrix figures of these
%Steady State



for i=1:1:a
    clearvars state
    if i==1
        state='CO2';
    elseif i==2
        state='Sober';
    elseif i==3
        state='Anes';
    end
    
    for j=1:1:1
        clearvars CurrentVals
        if j==1
            CurrentVals=MeanMean(i,:);
            valueType='Means';
        elseif j==2
            CurrentVals=MedianMean(i,:);
            valueType='Medians';
        elseif j==3
            CurrentVals=ModeMean(i,:);
            valueType='Modes';
        elseif j==4
            CurrentVals=RSqrTotGausMean(i,:);
            valueType='RSqrGaus';
        end
        
        
        CurrentVals=CurrentVals';
        CurrentNii=get_ValsMappedToAtlas_V3(CurrentVals, 174, blahblahblah);
        fileName=strcat(folder1,'/map_Rat_', valueType, '_', state, '_', s, '_Atlas');
        saveName=strcat(fileName, '.nii');
        save_nii(CurrentNii,saveName);
        %get_nii_to_stm_Custom_v2(CurrentNii, fileName, 1, 1, 1);
        
%         for k=1:1:2
%             if k==1
%                 layout='vertical';
%             elseif k==2
%                 layout='horizontal';
%             end
%             
%             CurrentImg=double(CurrentNii.img);
%             [FigureMatrixAxial] =get_AtlasFigure_v3(CurrentImg, Axial_slices, 'axial', layout);
%             [FigureMatrixCoronal] =get_AtlasFigure_v3(CurrentImg, Coronal_slices, 'coronal', layout);
%             
%             if PlotControl==1
%                 figure
%                 imagesc(FigureMatrixAxial)
%                 figure
%                 imagesc(FigureMatrixCoronal)
%             end
%             
%             saveName=strcat(folder2, '/Rat_', valueType, '_', state, '_', s, '_Atlas_Matrix_Axial_',layout,'.mat');
%             save(saveName,'FigureMatrixAxial')
%             saveName=strcat(folder2, '/Rat_', valueType, '_', state, '_', s, '_Atlas_Matrix_Coronal_',layout,'.mat');
%             save(saveName,'FigureMatrixCoronal')
%             
%         end
        
    end
end
%%
%Functional
for i=1:1:2
    
    clearvars state
    if i==1
        state='CO2-Air';
    elseif i==2
        state='Iso-Air';
    end
    
    for j=1:1:1
        clearvars CurrentVals
        if j==1
            CurrentVals=Mean_Diff_Mean(:,i);
            valueType='Means';
        elseif j==2
            CurrentVals=Median_Diff_Mean(:,i);
            valueType='Medians';
        elseif j==3
            CurrentVals=Mode_Diff_Mean(:,i);
            valueType='Modes';
        end
        
CurrentNii=get_ValsMappedToAtlas_V3(CurrentVals, 174, blahblahblah);
fileName=strcat(folder1,'/map_Rat_', valueType, '_', state, '_', s, '_Atlas');
        saveName=strcat(fileName, '.nii');
        save_nii(CurrentNii,saveName);
        %get_nii_to_stm_Custom_v2(CurrentNii, fileName, 1, 1, 1);
        
%         for k=1:1:2
%             if k==1
%                 layout='vertical';
%             elseif k==2
%                 layout='horizontal';
%             end
%             
%             CurrentImg=double(CurrentNii.img);
%             [FigureMatrixAxial] =get_AtlasFigure_v3(CurrentImg, Axial_slices, 'axial', layout);
%             [FigureMatrixCoronal] =get_AtlasFigure_v3(CurrentImg, Coronal_slices, 'coronal', layout);
%             
%             if PlotControl==1
%                 figure
%                 imagesc(FigureMatrixAxial)
%                 figure
%                 imagesc(FigureMatrixCoronal)
%             end
%             
%             
%             saveName=strcat(folder2, '/Rat_', valueType, '_', state, '_', s, '_Atlas_Matrix_Axial_',layout,'.mat');
%             save(saveName,'FigureMatrixAxial')
%             saveName=strcat(folder2, '/Rat_', valueType, '_', state, '_', s, '_Atlas_Matrix_Coronal_',layout,'.mat');
%             save(saveName,'FigureMatrixCoronal')
%             
%         end
%         
        
    end
end

%%
%Functional but only statistically significant
for i=1:1:2
    
    clearvars type
    if i==1
        state='CO2-Air';
    elseif i==2
        state='Iso-Air';
    end
    
    for j=1:1:1
        clearvars CurrentVals
        if j==1
            CurrentVals=Mean_Diff_Mean(:,i).*Mean_Diff_Ttest(:,i);
            valueType='Means';
        elseif j==2
            CurrentVals=Median_Diff_Mean(:,i).*Median_Diff_Ttest(:,i);
            valueType='Medians';
        elseif j==3
            CurrentVals=Mode_Diff_Mean(:,i).*Mode_Diff_Ttest(:,i);
            valueType='Modes';
        end
        
        %we need an extra step to avoid scrunching the atlas too much when
        %there are large regions without values.
        CurrentVals(CurrentVals==0)=1000;
        
        CurrentNii=get_ValsMappedToAtlas_V3(CurrentVals, 174, blahblahblah);
        CurrentNii.img(CurrentNii.img>100)=0;
        fileName=strcat(folder1,'/map_Rat_', valueType, '_', state, '_', s, '_Atlas');
        saveName=strcat(fileName, '.nii');
        save_nii(CurrentNii,saveName);
%         get_nii_to_stm_Custom_v2(CurrentNii, fileName, 1, 1, 1);
        
%         for k=1:1:2
%             if k==1
%                 layout='vertical';
%             elseif k==2
%                 layout='horizontal';
%             end
%             
%             CurrentImg=double(CurrentNii.img);
%             [FigureMatrixAxial] =get_AtlasFigure_v3(CurrentImg, Axial_slices, 'axial', layout);
%             [FigureMatrixCoronal] =get_AtlasFigure_v3(CurrentImg, Coronal_slices, 'coronal', layout);
%             
%             FigureMatrixAxial(FigureMatrixAxial==1000)=0;
%             FigureMatrixCoronal(FigureMatrixCoronal==1000)=0;
%             
%             if PlotControl==1
%                 figure
%                 imagesc(FigureMatrixAxial)
%                 figure
%                 imagesc(FigureMatrixCoronal)
%             end
%             
%             saveName=strcat(folder2, '/Rat_', valueType, '_', state, '_', s, '_Atlas_Matrix_Axial_',layout,'_OnlyStatSig.mat');
%             save(saveName,'FigureMatrixAxial')
%             saveName=strcat(folder2, '/Rat_', valueType, '_', state, '_', s, '_Atlas_Matrix_Coronal_',layout,'_OnlyStatSig.mat');
%             save(saveName,'FigureMatrixCoronal')
%             
%         end
        
    end
end


%% Histogram figures
for k=1:1:c
    figure
    hold on
    for j=1:1:11
        temp=cell2mat(myDataHistNorm(2,j,k));
        if ~isempty(temp)
            plot(temp(:,2),temp(:,1))

        end
    end
    hold off
    
end

%% more histogram figs
for k=1:1:c
    figure
    hold on
    temp=cell2mat(myDataHistNormSmushed(1,k));
    if ~isempty(temp)
        plot(temp(:,2),temp(:,1))
    end
    temp=cell2mat(myDataHistNormSmushed(2,k));
    if ~isempty(temp)
        plot(temp(:,2),temp(:,1))
    end
    
    temp=cell2mat(myDataHistNormSmushed(3,k));
    if ~isempty(temp)
        plot(temp(:,2),temp(:,1))
    end
    
    hold off
    
end

%% More CBV figures?

folder1='SD12_RAT_CBV_REDO';
folder2='figure_Matrices';
folder3='Atlas_Map_Files';
PlotControl=1;

valueType='RawCBV';

for j=1:1:6
    
    an=sprintf('%d', j);
    loadname=strcat(folder3,'/map_rSD12_', an, '_UTE3D_MAGNITUDE_IMAGE_174_REGION.nii');
    AtlasNii=special_load_nii(loadname);
    AtlasImg=double(AtlasNii.img);
    AtlasImg(isnan(AtlasImg))=0;
    AtlasImg(AtlasImg~=0)=1;
    
    Axial_slices =get_Slices(AtlasImg, 'axial', 10, 5);
    Coronal_slices =get_Slices(AtlasImg, 'coronal', 5, 5);
    
    for i=1:1:a
        clearvars state
        if i==1
            state='CO2';
        elseif i==2
            state='Sober';
        elseif i==3
            state='Anes';
        end
        
        scn=sprintf('%d', i);
        
        loadName=strcat('rSD12_', an, '_UTE3D_CBV_from_', scn, '_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2.nii');
        CBVNii=load_nii(loadname);
        CBVImg=double(CBVNii.img);
        
        CroppedImg=CBVImg.*AtlasImg;
        CroppedNii=CBVNii;
        CroppedNii.img=CroppedImg;
        
        for k=1:1:2
            if k==1
                layout='vertical';
            elseif k==2
                layout='horizontal';
            end
            
            [FigureMatrixAxial] =get_AtlasFigure_v3(CroppedImg, Axial_slices, 'axial', layout);
            [FigureMatrixCoronal] =get_AtlasFigure_v3(CroppedImg, Coronal_slices, 'coronal', layout);
            
            if PlotControl==1
                figure
                imagesc(FigureMatrixAxial)
                figure
                imagesc(FigureMatrixCoronal)
            end
            
            saveName=strcat(folder2, '/Rat_', valueType, '_', state, 'Cropped_Matrix_Axial_',layout,'.mat');
            %             save(saveName,'FigureMatrixAxial')
            saveName=strcat(folder2, '/Rat_', valueType, '_', state, '_', 'Cropped_Coronal_',layout,'.mat');
            %             save(saveName,'FigureMatrixCoronal')
            
        end
        
    end
    
end

