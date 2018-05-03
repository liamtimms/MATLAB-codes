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
load('myDataRaw_SD12_174.mat')

%% or construct the data structure
[myDataRaw] = get_myDataRaw(3, 12, 174);

%% If we want Raw Intensities
[myDataRaw_Intensity] = get_myDataRaw_Intensity(5, 12, 174);
myDataRaw=myDataRaw_Intensity;

%% set parameters for for-loops based on size
% delete animal 11
myDataRaw(:,7,:)=[];
[a b c]=size(myDataRaw)

%% Histogram Analysis and Individual Animal Processing
binsize=0.005; %initially we used .001 for calculating the data and .01 for displaying the histograms
% binsize=20;
filtsize=3; %currently the filtered versions are not used
plotControl=0; %set to 1 to create more plots along the way

[myDataRawSmushed, myDataHist, myDataHistSmushed, myDataHistNorm, myDataHistNormSmushed, myDataHistSmooth, myDataHistSmoothSmushed] =get_HistogramsFromMyDataRaw(myDataRaw, binsize, filtsize, plotControl);

%%

% [MeanVals, MedianVals, ModeVals, RSqrTotalGaussian, RSqrModeGaussian, FitInfo, ProblemRegions] =get_MeanMedianModeSD12(myDataRaw,myDataHist);
% [MeanVals, MedianVals, ModeVals, SkewVals, KurtosisVals, GMeanVals, HMeanVals, TMeanVals, RSqrOfTotalGaussian, RSqrOfModeGaussian, FitInfo, ProblemRegions] =get_DistributionCharacterizationSD12(myDataRaw,myDataHist)
% [MeanVals, MedianVals, ModeVals, SkewVals, KurtosisVals, TMeanVals, RMSVals, RSqrOfTotalGaussian, RSqrOfModeGaussian, FitInfo, ProblemRegions, WindowHistFit] =get_DistributionCharacterizationSD12_v2(myDataRaw,myDataHist);
% [MeanVals, MedianVals, ModeVals, SkewVals, KurtosisVals, TMeanVals, RMSVals, RSqrOfTotalGaussian, RSqrOfModeGaussian, FitInfo, ProblemRegions, WindowHistFit, FullHistFit, Res] =get_DistributionCharacterizationSD12_v2(myDataRaw,myDataHist);

% [MeanVals, MedianVals, MMDiffVals, RMSVals, ProblemRegions] = get_DistributionCharacterizationSD12_v5(myDataRaw);
[MeanVals, MedianVals, MMDiffVals, RMSVals, StdVals, ProblemRegions] =get_DistributionCharacterizationSD12_v6(myDataRaw);


%%
% State and Functional Analysis
NumStates=a;
NumAn=b;
NumReg=c;
alpha=0.05;
s=sprintf('%d',NumReg-1);

% [RSqrTotGausMean, RSqrTotGausStd, ~, ~, ~, ~] =get_SD12_Functional_State_Analysis_v2(RSqrTotalGaussian, alpha, NumStates, NumReg);
% [RSqrModeGausMean, RSqrModeGausStd, ~, ~, ~, ~] =get_SD12_Functional_State_Analysis_v2(RSqrModeGaussian, alpha, NumStates, NumReg);


[MeanMean, MeanStd, Mean_Diff, Mean_Diff_Mean, Mean_Diff_Std, Mean_Diff_Ttest, Mean_Diff_pVal, Mean_Diff_2StdTest] =get_SD12_Functional_Animal_Analysis_v2(MeanVals, alpha, NumStates, NumAn, NumReg);
[MedianMean, MedianStd, Median_Diff, Median_Diff_Mean, Median_Diff_Std, Median_Diff_Ttest, Median_Diff_pVal, Median_Diff_2StdTest] =get_SD12_Functional_Animal_Analysis_v2(MedianVals, alpha, NumStates, NumAn, NumReg);
[MMDiffMean, MMDiffStd, MMDiff_Diff, MMDiff_Diff_Mean, MMDiff_Diff_Std, MMDiff_Diff_Ttest, MMDiff_Diff_pVal, MMDiff_Diff_2StdTest] =get_SD12_Functional_Animal_Analysis_v2(MMDiffVals, alpha, NumStates, NumAn, NumReg);

% [ModeMean, ModeStd, Mode_Diff, Mode_Diff_Mean, Mode_Diff_Std, Mode_Diff_Ttest, Mode_Diff_pVal, Mode_Diff_2StdTest] =get_SD12_Functional_Animal_Analysis_v2(ModeVals, alpha, NumStates, NumAn, NumReg);


% [GMeanMean, GMeanStd, GMean_Diff, GMean_Diff_Mean, GMean_Diff_Std, GMean_Diff_Ttest, GMean_Diff_pVal, GMean_Diff_2StdTest] =get_SD12_Functional_Animal_Analysis_v2(GMeanVals, alpha, NumStates, NumAn, NumReg);
% [TMeanMean, TMeanStd, TMean_Diff, TMean_Diff_Mean, TMean_Diff_Std, TMean_Diff_Ttest, TMean_Diff_pVal, TMean_Diff_2StdTest] =get_SD12_Functional_Animal_Analysis_v2(TMeanVals, alpha, NumStates, NumAn, NumReg);
% [HMeanMean, HMeanStd, HMean_Diff, HMean_Diff_Mean, HMean_Diff_Std, HMean_Diff_Ttest, HMean_Diff_pVal, HMean_Diff_2StdTest] =get_SD12_Functional_Animal_Analysis_v2(HMeanVals, alpha, NumStates, NumAn, NumReg);

% [SkewMean, SkewStd, Skew_Diff, Skew_Diff_Mean, Skew_Diff_Std, Skew_Diff_Ttest, Skew_Diff_pVal, Skew_Diff_2StdTest] =get_SD12_Functional_Animal_Analysis_v2(SkewVals, alpha, NumStates, NumAn, NumReg);
% [KurtosisMean, KurtossisStd, Kurtosis_Diff, Kurtosis_Diff_Mean, Kurtosis_Diff_Std, Kurtosis_Diff_Ttest, Kurtosis_Diff_pVal, Kurtosis_Diff_2StdTest] =get_SD12_Functional_Animal_Analysis_v2(KurtosisVals, alpha, NumStates, NumAn, NumReg);
[RMSMean, RMSStd, RMS_Diff, RMS_Diff_Mean, RMS_Diff_Std, RMS_Diff_Ttest, RMS_Diff_pVal, RMS_Diff_2StdTest] =get_SD12_Functional_Animal_Analysis_v2(RMSVals, alpha, NumStates, NumAn, NumReg);


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
Axial_slices =get_Slices(AtlasImg, 'axial', 10, 5);
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
%%
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
    
    for j=1:1:4
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
        CurrentNii=get_ValsMappedToAtlas_V2(CurrentVals);
        fileName=strcat(folder1,'/map_Rat_', valueType, '_', state, '_', s, '_Atlas');
        saveName=strcat(fileName, '.nii');
        save_nii(CurrentNii,saveName);
        get_nii_to_stm_Custom_v2(CurrentNii, fileName, 1, 1, 1);
        
        for k=1:1:2
            if k==1
                layout='vertical';
            elseif k==2
                layout='horizontal';
            end
            
            CurrentImg=double(CurrentNii.img);
            [FigureMatrixAxial] =get_AtlasFigure_v3(CurrentImg, Axial_slices, 'axial', layout);
            [FigureMatrixCoronal] =get_AtlasFigure_v3(CurrentImg, Coronal_slices, 'coronal', layout);
            
            if PlotControl==1
                figure
                imagesc(FigureMatrixAxial)
                figure
                imagesc(FigureMatrixCoronal)
            end
            
            saveName=strcat(folder2, '/Rat_', valueType, '_', state, '_', s, '_Atlas_Matrix_Axial_',layout,'.mat');
            save(saveName,'FigureMatrixAxial')
            saveName=strcat(folder2, '/Rat_', valueType, '_', state, '_', s, '_Atlas_Matrix_Coronal_',layout,'.mat');
            save(saveName,'FigureMatrixCoronal')
            
        end
        
    end
end

%Functional
for i=1:1:2
    
    clearvars state
    if i==1
        state='CO2-Air';
    elseif i==2
        state='Iso-Air';
    end
    
    for j=1:1:3
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
        
        CurrentNii=get_ValsMappedToAtlas_V2(CurrentVals);
        fileName=strcat(folder1,'/map_Rat_', valueType, '_', state, '_', s, '_Atlas');
        saveName=strcat(fileName, '.nii');
        save_nii(CurrentNii,saveName);
        get_nii_to_stm_Custom_v2(CurrentNii, fileName, 1, 1, 1);
        
        for k=1:1:2
            if k==1
                layout='vertical';
            elseif k==2
                layout='horizontal';
            end
            
            CurrentImg=double(CurrentNii.img);
            [FigureMatrixAxial] =get_AtlasFigure_v3(CurrentImg, Axial_slices, 'axial', layout);
            [FigureMatrixCoronal] =get_AtlasFigure_v3(CurrentImg, Coronal_slices, 'coronal', layout);
            
            if PlotControl==1
                figure
                imagesc(FigureMatrixAxial)
                figure
                imagesc(FigureMatrixCoronal)
            end
            
            
            saveName=strcat(folder2, '/Rat_', valueType, '_', state, '_', s, '_Atlas_Matrix_Axial_',layout,'.mat');
            save(saveName,'FigureMatrixAxial')
            saveName=strcat(folder2, '/Rat_', valueType, '_', state, '_', s, '_Atlas_Matrix_Coronal_',layout,'.mat');
            save(saveName,'FigureMatrixCoronal')
            
        end
        
        
    end
end

%Functional but only statistically significant
for i=1:1:2
    
    clearvars type
    if i==1
        state='CO2-Air';
    elseif i==2
        state='Iso-Air';
    end
    
    for j=1:1:3
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
        
        CurrentNii=get_ValsMappedToAtlas_V2(CurrentVals);
        fileName=strcat(folder1,'/map_Rat_', valueType, '_', state, '_', s, '_Atlas');
        saveName=strcat(fileName, '.nii');
        save_nii(CurrentNii,saveName);
        get_nii_to_stm_Custom_v2(CurrentNii, fileName, 1, 1, 1);
        
        for k=1:1:2
            if k==1
                layout='vertical';
            elseif k==2
                layout='horizontal';
            end
            
            CurrentImg=double(CurrentNii.img);
            [FigureMatrixAxial] =get_AtlasFigure_v3(CurrentImg, Axial_slices, 'axial', layout);
            [FigureMatrixCoronal] =get_AtlasFigure_v3(CurrentImg, Coronal_slices, 'coronal', layout);
            
            FigureMatrixAxial(FigureMatrixAxial==1000)=0;
            FigureMatrixCoronal(FigureMatrixCoronal==1000)=0;
            
            if PlotControl==1
                figure
                imagesc(FigureMatrixAxial)
                figure
                imagesc(FigureMatrixCoronal)
            end
            
            saveName=strcat(folder2, '/Rat_', valueType, '_', state, '_', s, '_Atlas_Matrix_Axial_',layout,'_OnlyStatSig.mat');
            save(saveName,'FigureMatrixAxial')
            saveName=strcat(folder2, '/Rat_', valueType, '_', state, '_', s, '_Atlas_Matrix_Coronal_',layout,'_OnlyStatSig.mat');
            save(saveName,'FigureMatrixCoronal')
            
        end
        
    end
end


%%
for k=52:1:52
    figure
    hold on
    for j=1:1:5
        temp=cell2mat(myDataHistNorm(1,j,k));
        if ~isempty(temp)
            plot(temp(:,2),temp(:,1))

        end
    end
    hold off
    
end

%%
for k=1:1:c
    figure
    hold on
    temp=cell2mat(myDataHistNormSmushed(3,k));
    if ~isempty(temp)
        plot(temp(:,2),temp(:,1))
    end
    temp=cell2mat(myDataHistNormSmushed(4,k));
    if ~isempty(temp)
        plot(temp(:,2),temp(:,1))
    end
    
    temp=cell2mat(myDataHistNormSmushed(5,k));
    if ~isempty(temp)
        plot(temp(:,2),temp(:,1))
    end
    
    hold off
    
end

%%

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

