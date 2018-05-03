%% Create and initate the object
clear
clc
close all
%%
load('myDataRaw_SD12_174.mat')

%Edit out 7
myDataRaw(:,7,:)=[];

[a b c]=size(myDataRaw)

%%
% myDataRaw is a 4x12x175 cell array with
% (sober1,CO2,sober2,anes)x(animal num)x(region number)
% mydataSmooth=cell(size(myDataRaw));

resolution=0.002;
filtsize=3;
plotControl=0;

% ----Squish all animals into one concatenated representative animal -----
% myDataRawSmushed is 4x175 cell array with all animals counted
myDataRawSmushed=cell(a,c);
for i=1:1:a
    for j=1:1:c
        for k=1:1:b
            myDataRawSmushed(i,j)={[cell2mat(myDataRawSmushed(i,j)); cell2mat(myDataRaw(i,k,j))]};
        end
    end
end

% ----- Generate Histogram for finding Mode with Gauss Fit -----
% mydataHist and mydataHistSmooth are 4x12x175(countsXbins)cell arrays
mydataHist=cell(size(myDataRaw));
mydataHistSmooth=cell(size(myDataRaw));
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
            if plotControl==1 && a==3
                plot(histBins,histCounts)
            end
            mydataHist(i,j,k)={[histCounts;histBins]'};
            mydataHistSmooth(i,j,k)={[medfilt1(histCounts,filtsize);histBins]'};
        end
        hold off
    end
end

% mydataSmooth is a 4x12x175 cell array with of Raw smoothed
mydataHistSmushed=cell(size(myDataRawSmushed));
mydataHistSmoothSmushed=cell(size(myDataRawSmushed));

for i=1:1:a
    for k=1:1:c
        maxVal=max(cell2mat(myDataRawSmushed(i,k)));
        minVal=min(cell2mat(myDataRawSmushed(i,k)));
        nbins=(maxVal-minVal)/resolution;
        [histCounts,histBins]=hist(reshape(cell2mat(myDataRawSmushed(i,k)),[],1),nbins);
        mydataHistSmushed(i,k)={[histCounts;histBins]'};
        mydataHistSmoothSmushed(i,k)={[medfilt1(histCounts,filtsize);histBins]'};
    end
    
end
%% Get Mean, median and mode for each rat and region individually
ModeVals=zeros(size(myDataRaw));
MeanVals=zeros(size(myDataRaw));
MedianVals=zeros(size(myDataRaw));

currentData=mydataHist;
banana=0

for i=1:1:a
    i
    for j=1:1:b
        
        for k=1:1:c
            clearvars temp X
            temp=cell2mat(currentData(i,j,k));
            
            if isempty(temp)
                banana=1+banana
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
                
                [~,GOF,~,~,~,xi,yi]=peakfit(signal,center,window,NumPeaks,peakshape,extra,NumTrials);
                peak=0;
                
                [M,I]=max(yi);
                ModeVals(i,j,k)=xi(I);
                
                MeanVals(i,j,k)=mean(cell2mat(myDataRaw(i,j,k)));
                MedianVals(i,j,k)=median(cell2mat(myDataRaw(i,j,k)));
            end
            
        end
    end
end

%% For looking at all the individual regions with all animals combined
Regions=[54 105]

s=size(Regions);
figure

hold on
for i=1:1:s(2)
    
    n=Regions(i);
    temp=cell2mat(mydataHistSmoothSmushed(1,n));
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

for i=1:1:174
    
    temp=cell2mat(mydataHistSmoothSmushed(1,i));
    Y_vals=temp(:,1);
    X_vals=temp(:,2);
    
    if max(Y_vals)>300 && max(Y_vals)<400
        i
        plot(X_vals,Y_vals)
    end
end

hold off


%% For looking at histograms for a single scan with all available animals with the area under the curve normalized to 1
mydataHistNorm=cell(size(mydataHist));
mydataHistNormSmushed=cell(size(mydataHistSmushed));


for k=1:1:c
    figure
    hold on
    for i=1:1:a
        
        temp=cell2mat(mydataHistSmushed(i,k));
        
        if ~isempty(temp)
            histCounts=temp(:,1);
            histBins=temp(:,2);
            histNorm=histCounts/trapz(histBins,histCounts);
            mydataHistNormSmushed(i,k)={[histNorm,histBins]};
        end
        
        for j=1:1:b
            
            temp=cell2mat(mydataHist(i,j,k));
            if ~isempty(temp)
                histCounts=temp(:,1);
                histBins=temp(:,2);
                histNorm=histCounts/trapz(histBins,histCounts);
                if a==3
                    plot(histBins,histNorm)
                end
                
                mydataHistNorm(i,j,k)={[histNorm,histBins]};
            end
        end
        hold off
    end
end



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
