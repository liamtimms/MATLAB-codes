% % % % % % % %  SD12 Functional Redo   % % % % % % % %
% % % % % % % %    Liam Timms 6/7/16    % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

%Note: This code is designed to work with the new data structure and
%analysis implemented in "CAG_Code_v3_LT"
clearvars -except ModeVals MeanVals MedianVals myDataRaw mydataHist

%% First we want to do state by state analysis
NumAn=11;
NumReg=c;
alpha=0.05;
s=sprintf('%d',NumReg-1);


%lets try just looking at the differences with error propogation
[MeanMean, MeanStd, MeanMean_Diff, MeanMean_Diff_Error, MeanMean_Diff_Ttest, MeanMean_Diff_pVal] =get_SD12_Functional_State_Analysis(MeanVals, alpha, NumReg);
[MedianMean, MedianStd, MedianMean_Diff, MedianMean_Diff_Error, MedianMean_Diff_Ttest, MedianMean_Diff_pVal] =get_SD12_Functional_State_Analysis(MedianVals, alpha, NumReg);
[ModeMean, ModeStd, ModeMean_Diff, ModeMean_Diff_Error, ModeMean_Diff_Ttest, ModeMean_Diff_pVal] =get_SD12_Functional_State_Analysis(ModeVals, alpha, NumReg);


%% Second we want to do animal by animal analysis
[Mean_Diff, Mean_Diff_Mean, Mean_Diff_Std, Mean_Diff_Ttest, Mean_Diff_pVal] =get_SD12_Functional_Animal_Analysis(MeanVals, alpha, NumAn, NumReg);
[Median_Diff, Median_Diff_Mean, Median_Diff_Std, Median_Diff_Ttest, Median_Diff_pVal] =get_SD12_Functional_Animal_Analysis(MedianVals, alpha, NumAn, NumReg);
[Mode_Diff, Mode_Diff_Mean, Mode_Diff_Std, Mode_Diff_Ttest, Mode_Diff_pVal] =get_SD12_Functional_Animal_Analysis(ModeVals, alpha, NumAn, NumReg);

%%
for i=1:1:NumAn
    
    for j=1:1:NumReg
        
        for k=1:1:3
            MeanMode_Diff(i,j,k)=abs(MeanVals(k,i,j)-ModeVals(k,i,j));
        end
        
    end
end

for j=1:1:NumReg
    for k=1:1:3
        RSqrGausMean(j,k)=mean(RSqrOfTotalGaussian(k,:,j));
        Diff_MM_Mean(j,k)=mean(MeanMode_Diff(:,j,k));
        Diff_MM_Std(j,k)=std(MeanMode_Diff(:,j,k));
        [Diff_MM_Ttest(j,k), Diff_MM_pVal(j,k)]=ttest(MeanMode_Diff(:,j,k));
    end
end
%% Now we map these onto the atlas, just steady state

for i=1:1:3
    
    clearvars x y z w
    x=MeanMean(i,:);
    x=x';
    [MeanMean_Nii]=get_ValsMappedToAtlas_V2(x);
    
    
    y=ModeMean(i,:);
    y=y';
    [ModeMean_Nii]=get_ValsMappedToAtlas_V2(y);
    
    z=MedianMean(i,:);
    z=z';
    [MedianMean_Nii]=get_ValsMappedToAtlas_V2(z);
    
    w=RSqrGausMean(:,i);
    [RSqrGausMean_Nii]=get_ValsMappedToAtlas_V2(w);
    
    if i==1
        type='CO2';
    elseif i==2
        type='Sober';
    elseif i==3
        type='Anes';
    end
    
    saveName=strcat('map_Rat_Means_',type,'_', s, '_Atlas.nii');
    save_nii(MeanMean_Nii,saveName);
    
    saveName=strcat('map_Rat_Modes_',type,'_', s, '_Atlas.nii');
    save_nii(ModeMean_Nii,saveName);
    
    saveName=strcat('map_Rat_Medians_',type,'_', s, '_Atlas.nii');
    save_nii(MedianMean_Nii,saveName);
    
    saveName=strcat('map_Rat_RSqrGaus_',type,'_', s, '_Atlas.nii');
    save_nii(RSqrGausMean_Nii,saveName);
    
    view_nii(MeanMean_Nii)
    view_nii(MedianMean_Nii)
    view_nii(ModeMean_Nii)
    
end
%% mapping onto atlas, functional

for i=1:1:2
    
    [MeanDifferenceOf_Means_Nii]   =get_ValsMappedToAtlas_V2(Mean_Diff_Mean(:,i));
    [MeanDifferenceOf_Modes_Nii]   =get_ValsMappedToAtlas_V2(Mode_Diff_Mean(:,i));
    [MeanDifferenceOf_Medians_Nii] =get_ValsMappedToAtlas_V2(Median_Diff_Mean(:,i));
    
    if i==1
        type='CO2-Sober';
    elseif i==2
        type='Anes-Sober';
    end
    
    saveName=strcat('map_Rat_Means_',type,'_', s, '_Atlas.nii')
    save_nii(MeanDifferenceOf_Means_Nii,saveName);
    
    saveName=strcat('map_Rat_Modes_',type,'_', s, '_Atlas.nii')
    save_nii(MeanDifferenceOf_Modes_Nii,saveName);
    
    saveName=strcat('map_Rat_Medians_',type,'_', s, '_Atlas.nii')
    save_nii(MeanDifferenceOf_Medians_Nii,saveName);
    
end

%% mapping onto atlas, functional BUT ONLY SIGNIFICANT CHANGES

for i=1:1:2
    clearvars X Y Z
    
    X=Mean_Diff_Mean.*Mean_Diff_Ttest;
    Y=Median_Diff_Mean.*Median_Diff_Ttest;
    Z=Mode_Diff_Mean.*Mode_Diff_Ttest;
    
    [MeanDifferenceOf_Means_Nii]   =get_ValsMappedToAtlas_V2(X(:,i));
    [MeanDifferenceOf_Modes_Nii]   =get_ValsMappedToAtlas_V2(Y(:,i));
    [MeanDifferenceOf_Medians_Nii] =get_ValsMappedToAtlas_V2(Z(:,i));
    
    if i==1
        type='CO2-Sober';
    elseif i==2
        type='Anes-Sober';
    end
    
    saveName=strcat('map_Rat_Means_',type,'_', s, '_Atlas_OnlySig.nii')
    save_nii(MeanDifferenceOf_Means_Nii,saveName);
    
    saveName=strcat('map_Rat_Modes_',type,'_', s, '_Atlas_OnlySig.nii')
    save_nii(MeanDifferenceOf_Modes_Nii,saveName);
    
    saveName=strcat('map_Rat_Medians_',type,'_', s, '_Atlas_OnlySig.nii')
    save_nii(MeanDifferenceOf_Medians_Nii,saveName);
    
end

%% Now we will make all the figures

Axial_slices=[10 13 20 25 30 34 39 42 47 51 53 61]; %used for axial
Coronal_slices=[113 125 149 176]; % Used for Coronal

%%
% [FigureMatrix] =get_AtlasFigure(AtlasImg, slices, direction)

s=sprintf('%d',NumReg-1);
folder='figure_Matrices';

for i=1:1:3
    
    if i==1
        type='CO2';
    elseif i==2
        type='Sober';
    elseif i==3
        type='Anes';
    end
    
    loadName=strcat('map_Rat_Means_',type,'_', s, '_Atlas.nii')
    MeansAtlasNii=load_nii(loadName);
    MeansAtlasImg=double(MeansAtlasNii.img);
    [FigureMatrixMeansAxial] =get_AtlasFigure(MeansAtlasImg, Axial_slices, 'axial');
    [FigureMatrixMeansCoronal] =get_AtlasFigure(MeansAtlasImg, Coronal_slices, 'coronal');
    saveName=strcat(folder, '/Rat_Means_', type,'_', s, '_Atlas_Matrix_Axial.mat');
    save(saveName,'FigureMatrixMeansAxial')
    saveName=strcat(folder, '/Rat_Means_', type,'_', s, '_Atlas_Matrix_Coronal.mat');
    save(saveName,'FigureMatrixMeansCoronal')
    
    loadName=strcat('map_Rat_Modes_',type,'_', s, '_Atlas.nii')
    ModesAtlasNii=load_nii(loadName);
    ModesAtlasImg=double(ModesAtlasNii.img);
    [FigureMatrixModesAxial] =get_AtlasFigure(ModesAtlasImg, Axial_slices, 'axial');
    [FigureMatrixModesCoronal] =get_AtlasFigure(ModesAtlasImg, Coronal_slices, 'coronal');
    saveName=strcat(folder, '/Rat_Modes_', type,'_', s, '_Atlas_Matrix_Axial.mat');
    save(saveName,'FigureMatrixModesAxial')
    saveName=strcat(folder, '/Rat_Modes_', type,'_', s, '_Atlas_Matrix_Coronal.mat');
    save(saveName,'FigureMatrixModesCoronal')
    
    
    loadName=strcat('map_Rat_Medians_',type,'_', s, '_Atlas.nii')
    MediansAtlasNii=load_nii(loadName);
    MediansAtlasImg=double(MediansAtlasNii.img);
    [FigureMatrixMediansAxial] =get_AtlasFigure(MediansAtlasImg, Axial_slices, 'axial');
    [FigureMatrixMediansCoronal] =get_AtlasFigure(MediansAtlasImg, Coronal_slices, 'coronal');
    saveName=strcat(folder, '/Rat_Medians_', type,'_', s, '_Atlas_Matrix_Axial.mat');
    save(saveName,'FigureMatrixMediansAxial')
    saveName=strcat(folder, '/Rat_Medians_', type,'_', s, '_Atlas_Matrix_Coronal.mat');
    save(saveName,'FigureMatrixMediansCoronal')
    
    
end

%%

for i=1:1:2
    
    if i==1
        type='CO2-Sober';
    elseif i==2
        type='Anes-Sober';
    end
    
    loadName=strcat('map_Rat_Means_',type,'_', s, '_Atlas.nii')
    MeansAtlasNii=load_nii(loadName);
    MeansAtlasImg=double(MeansAtlasNii.img);
    [FigureMatrixMeansAxial] =get_AtlasFigure(MeansAtlasImg, Axial_slices, 'axial');
    [FigureMatrixMeansCoronal] =get_AtlasFigure(MeansAtlasImg, Coronal_slices, 'coronal');
    max(FigureMatrixMeansAxial)
    max(FigureMatrixMeansCoronal)
    saveName=strcat(folder, '/Rat_Means_', type,'_', s, '_Atlas_Matrix_Axial.mat');
    save(saveName,'FigureMatrixMeansAxial')
    saveName=strcat(folder, '/Rat_Means_', type,'_', s, '_Atlas_Matrix_Coronal.mat');
    save(saveName,'FigureMatrixMeansCoronal')
    
    loadName=strcat('map_Rat_Modes_',type,'_', s, '_Atlas.nii')
    ModesAtlasNii=load_nii(loadName);
    ModesAtlasImg=double(ModesAtlasNii.img);
    [FigureMatrixModesAxial] =get_AtlasFigure(ModesAtlasImg, Axial_slices, 'axial');
    [FigureMatrixModesCoronal] =get_AtlasFigure(ModesAtlasImg, Coronal_slices, 'coronal');
    saveName=strcat(folder, '/Rat_Modes_', type,'_', s, '_Atlas_Matrix_Axial.mat');
    save(saveName,'FigureMatrixModesAxial')
    saveName=strcat(folder, '/Rat_Modes_', type,'_', s, '_Atlas_Matrix_Coronal.mat');
    save(saveName,'FigureMatrixModesCoronal')
    
    loadName=strcat('map_Rat_Medians_',type,'_', s, '_Atlas.nii')
    MediansAtlasNii=load_nii(loadName);
    MediansAtlasImg=double(MediansAtlasNii.img);
    [FigureMatrixMedianAxial] =get_AtlasFigure(MediansAtlasImg, Axial_slices, 'axial');
    [FigureMatrixMediansCoronal] =get_AtlasFigure(MediansAtlasImg, Coronal_slices, 'coronal');
    saveName=strcat(folder, '/Rat_Medians_', type,'_', s, '_Atlas_Matrix_Axial.mat');
    save(saveName,'FigureMatrixMediansAxial')
    saveName=strcat(folder, '/Rat_Medians_', type,'_', s, '_Atlas_Matrix_Coronal.mat');
    save(saveName,'FigureMatrixMediansCoronal')
    
    
end

%%

for i=1:1:2
    
    if i==1
        type='CO2-Sober';
    elseif i==2
        type='Anes-Sober';
    end
    
    loadName=strcat('map_Rat_Means_',type,'_', s, '_Atlas_OnlySig.nii')
    MeansAtlasNii=load_nii(loadName);
    MeansAtlasImg=double(MeansAtlasNii.img);
    [FigureMatrixMeansAxial] =get_AtlasFigure(MeansAtlasImg, Axial_slices, 'axial');
    [FigureMatrixMeansCoronal] =get_AtlasFigure(MeansAtlasImg, Coronal_slices, 'coronal');
    max(FigureMatrixMeansAxial)
    max(FigureMatrixMeansCoronal)
    saveName=strcat(folder, '/Rat_Means_', type,'_', s, '_Atlas_Matrix_Axial.mat');
    save(saveName,'FigureMatrixMeansAxial')
    saveName=strcat(folder, '/Rat_Means_', type,'_', s, '_Atlas_Matrix_Coronal.mat');
    save(saveName,'FigureMatrixMeansCoronal')
    
    loadName=strcat('map_Rat_Modes_',type,'_', s, '_Atlas_OnlySig.nii')
    ModesAtlasNii=load_nii(loadName);
    ModesAtlasImg=double(ModesAtlasNii.img);
    [FigureMatrixModesAxial] =get_AtlasFigure(ModesAtlasImg, Axial_slices, 'axial');
    [FigureMatrixModesCoronal] =get_AtlasFigure(ModesAtlasImg, Coronal_slices, 'coronal');
    saveName=strcat(folder, '/Rat_Modes_', type,'_', s, '_Atlas_Matrix_Axial.mat');
    save(saveName,'FigureMatrixModesAxial')
    saveName=strcat(folder, '/Rat_Modes_', type,'_', s, '_Atlas_Matrix_Coronal.mat');
    save(saveName,'FigureMatrixModesCoronal')
    
    loadName=strcat('map_Rat_Medians_',type,'_', s, '_Atlas_OnlySig.nii')
    MediansAtlasNii=load_nii(loadName);
    MediansAtlasImg=double(MediansAtlasNii.img);
    [FigureMatrixMedianAxial] =get_AtlasFigure(MediansAtlasImg, Axial_slices, 'axial');
    [FigureMatrixMediansCoronal] =get_AtlasFigure(MediansAtlasImg, Coronal_slices, 'coronal');
    saveName=strcat(folder, '/Rat_Medians_', type,'_', s, '_Atlas_Matrix_Axial.mat');
    save(saveName,'FigureMatrixMediansAxial')
    saveName=strcat(folder, '/Rat_Medians_', type,'_', s, '_Atlas_Matrix_Coronal.mat');
    save(saveName,'FigureMatrixMediansCoronal')
    
    
end


%% Comparing Histograms of Regions with Significant Differences

state=1;
% M=Mean_Diff_Mean;
% Mstd=Mean_Diff_Std;
T=Mean_Diff_Ttest;

n=0;

for i=1:1:NumReg
    
    if T(i,state)==1
        n=n+1;
        figure
        hold on
        temp=cell2mat(mydataHistNormSmushed(state,i));
        Y_vals=temp(:,1);
        X_vals=temp(:,2);
        plot(X_vals,Y_vals)
        
        
        temp=cell2mat(mydataHistNormSmushed(2,i));
        Y_vals=temp(:,1);
        X_vals=temp(:,2);
        plot(X_vals,Y_vals)
        
        RelRegs(n)=i;
        hold off
        
    end
    
end

