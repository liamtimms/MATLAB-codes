function [myDataRawSmushed, myDataHist, myDataHistSmushed, myDataHistNorm, myDataHistNormSmushed, myDataHistSmooth, myDataHistSmoothSmushed] =get_HistogramsFromMyDataRaw(myDataRaw, binsize, filtsize, plotControl)

% myDataRaw was initially a 4x12x175 cell array with
% (sober1,CO2,sober2,anes)x(animal num)x(region number)
% now we discard "sober1" and animal 11

[a b c]=size(myDataRaw);

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
            nbins=(maxVal-minVal)/binsize;
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
        nbins=(maxVal-minVal)/binsize;
        [histCounts,histBins]=hist(reshape(cell2mat(myDataRawSmushed(i,k)),[],1),nbins);
        myDataHistSmushed(i,k)={[histCounts;histBins]'};
        myDataHistSmoothSmushed(i,k)={[medfilt1(histCounts,filtsize);histBins]'};
    end
    
end

% For looking at histograms for a single scan with all available animals with the area under the curve normalized to 1
myDataHistNorm=cell(size(myDataHist));
myDataHistNormSmushed=cell(size(myDataHistSmushed));


for k=1:1:c
    
    if plotControl==1
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
                if plotControl==1 && a==3
                    plot(histBins,histNorm)
                end
                
                myDataHistNorm(i,j,k)={[histNorm,histBins]};
            end
        end
        hold off
    end
end
end