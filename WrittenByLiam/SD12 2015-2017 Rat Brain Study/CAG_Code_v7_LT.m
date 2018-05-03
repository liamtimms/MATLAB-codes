%% Clean workspace
clear
clc
close all
%% load old data structure
load('myDataRaw_SD12_174.mat')

%% or construct the data structure
[myDataRaw] =get_myDataRaw(3, 12, 174)

%% delete animal 11
myDataRaw(:,7,:)=[];

%% set parameters for for-loops based on size
[a b c]=size(myDataRaw)

%%
% myDataRaw was initially a 4x12x175 cell array with
% (sober1,CO2,sober2,anes)x(animal num)x(region number)
% now we discard "sober1" and animal 11

resolution=0.005; %initially we used .001 for calculating the data and .01 for displaying the histograms
filtsize=3; %currently the filtered versions are not used
plotControl=0; %set to 1 to create more plots along the way

% ---- Squish all animals into one concatenated representative animal -----
% myDataRawSmushed is 4x175 cell array with all animals counted
myDataRawSmushed=cell(a,c);
for i=1:1:a
    for j=1:1:c
        for k=1:1:b
            myDataRawSmushed(i,j)={[cell2mat(myDataRawSmushed(i,j)); cell2mat(myDataRaw(i,k,j))]};
        end
    end
end

% ----- Generate Histogram for finding Mode with Gaussian Fit -----
% myDataHist and myDataHistSmooth are 4x12x175(countsXbins)cell arrays
myDataHist       =cell(size(myDataRaw));
myDataHistSmooth =cell(size(myDataRaw));

for k=1:1:c
    if plotControl==1
        figure
    end
    for i=1:1:a
        hold on
        for j=1:1:b
            maxVal=max(cell2mat(myDataRaw(i,j,k)));
            minVal=min(cell2mat(myDataRaw(i,j,k)));
            nbins=(maxVal-minVal)/resolution;
            [histCounts,histBins]=hist(reshape(cell2mat(myDataRaw(i,j,k)),[],1),nbins);
            
            if plotControl==1 && a==3 %a==1 for CO2, a==2 for air, a==3 for iso
                plot(histBins,histCounts)
            end
            
            myDataHist(i,j,k)={[histCounts;histBins]'};
            myDataHistSmooth(i,j,k)={[medfilt1(histCounts,filtsize);histBins]'};
        end
        hold off
    end
end

% Now we do a version of that using the "smushed" data
myDataHistSmushed=cell(size(myDataRawSmushed));
myDataHistSmoothSmushed=cell(size(myDataRawSmushed));

for i=1:1:a
    for k=1:1:c
        maxVal=max(cell2mat(myDataRawSmushed(i,k)));
        minVal=min(cell2mat(myDataRawSmushed(i,k)));
        nbins=(maxVal-minVal)/resolution;
        [histCounts,histBins]=hist(reshape(cell2mat(myDataRawSmushed(i,k)),[],1),nbins);
        myDataHistSmushed(i,k)={[histCounts;histBins]'};
        myDataHistSmoothSmushed(i,k)={[medfilt1(histCounts,filtsize);histBins]'};
    end
    
end
%%
% For looking at histograms for a single scan with all available animals with the area under the curve normalized to 1
myDataHistNorm=cell(size(myDataHist));
myDataHistNormSmushed=cell(size(myDataHistSmushed));


for k=1:1:c
    
    if plotcontrol==1
        figure
    end
    
    hold on
    for i=1:1:a
        
        temp=cell2mat(myDataHistSmushed(i,k));
        
        if ~isempty(temp)
            histCounts=temp(:,1);
            histBins=temp(:,2);
            histNorm=histCounts/trapz(histBins,histCounts);
            myDataHistNormSmushed(i,k)={[histNorm,histBins]};
        end
        
        for j=1:1:b
            
            temp=cell2mat(myDataHist(i,j,k));
            if ~isempty(temp)
                histCounts=temp(:,1);
                histBins=temp(:,2);
                histNorm=histCounts/trapz(histBins,histCounts);
                if plotcontrol==1 && a==3
                    plot(histBins,histNorm)
                end
                
                myDataHistNorm(i,j,k)={[histNorm,histBins]};
            end
        end
        hold off
    end
end



%%
% Get mean, median and mode for each rat and region individually
MeanVals=NaN(size(myDataRaw));
MedianVals=NaN(size(myDataRaw));
ModeVals=NaN(size(myDataRaw));

currentData=myDataHist; % change this to myDataHistSmooth to use filtered version
ProblemRegions=0;

for i=1:1:a
    i
    NumOfProblemRegions=0;
    
    for j=1:1:b
        for k=1:1:c
            
            % finding mean and median is trivial
            MeanVals(i,j,k)=nanmean(cell2mat(myDataRaw(i,j,k)));
            MedianVals(i,j,k)=nanmedian(cell2mat(myDataRaw(i,j,k)));
            
            % now finding the mode...
            clearvars temp X
            temp=cell2mat(currentData(i,j,k));
            
            if isempty(temp)
                NumOfProblemRegions=1+NumOfProblemRegions;
                ProblemRegions=[ProblemRegions, k];
            else
                X(:,1)=temp(:,2);
                X(:,2)=temp(:,1);
                
                [M,I]=max(X(:,2));
                signal=X;
                center=X(I,1);
                window=0.1;
                NumPeaks=1;
                peakshape=0;
                extra=0;
                NumTrials=5;
                
                [FitResults, GOF,~,~,~,xi,yi]=peakfit(signal,center,window,NumPeaks,peakshape,extra,NumTrials);
                FitInfo(i,j,k)={[FitResults]};
                RSqrOfModeGaussian(i,j,k)=GOF(1,2);
                
                [M,I]=max(yi);
                ModeVals(i,j,k)=xi(I); % Mode finally!
                
                
                % Now we quantify the gaussian-ness of the whole
                % distribution
                center=0;
                window=0;
                NumPeaks=1;
                peakshape=0;
                extra=0;
                NumTrials=5;
                [~,GOF,~,~,~,~,~]=peakfit(signal,center,window,NumPeaks,peakshape,extra,NumTrials);
                RSqrOfTotalGaussian(i,j,k)=GOF(1,2);
                
            end
            NumOfProblemRegions
        end
        
    end
end

%% For at specific regions
Regions=[125 135 157]

s=size(Regions);
figure

hold on
for i=1:1:s(2)
    
    n=Regions(i);
    temp=cell2mat(myDataHistNormSmushed(1,n));
    Y_vals=temp(:,1);
    X_vals=temp(:,2);
    
    %     figure
    plot(X_vals,Y_vals)
end

hold off

%% For highlighting regions with a particular range of max values on a single graph
%(useful for getting a sense of all the different shapes at once)

figure
hold on

for i=1:1:132
    
    temp=cell2mat(myDataHistNormSmushed(2,i));
    Y_vals=temp(:,1);
    X_vals=temp(:,2);
    
    if max(X_vals)>1 %&& max(Y_vals)<400
        i
        plot(X_vals,Y_vals)
    end
end

hold off



%% Cut-off Analysis

cutoff=0;
step=.1;

for l=1:1:10
    
    for k=1:1:c
        for i=1:1:a
            for j=1:1:b
                
                
                CurrentData=cell2mat(myDataRaw(i,j,k));
                if ~isempty(CurrentData)
                    KernelFit(i,j,k)={fitdist(CurrentData,'kernel');};
                end
                total=size(nonzeros(CurrentData));
                CurrentData(CurrentData<cutoff)=0;
                num_above=size(nonzeros(CurrentData));
                PercentAbove(i,j,k,l)=num_above(1,1)/total(1,1);
                
            end
        end
        PercentAboveAve(k,l)=nanmean(PercentAbove(3,:,k,l));
        PercentAboveStd(k,l)=nanstd(PercentAbove(3,:,k,l));
    end
    
    
    
    cutoff=cutoff+step;
    
end
