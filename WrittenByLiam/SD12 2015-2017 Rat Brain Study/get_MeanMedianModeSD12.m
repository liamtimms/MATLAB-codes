function [MeanVals, MedianVals, ModeVals, RSqrOfTotalGaussian, RSqrOfModeGaussian, FitInfo, ProblemRegions] =get_MeanMedianModeSD12(myDataRaw,myDataHist)
[a b c]=size(myDataRaw);
MeanVals=NaN(size(myDataRaw));
MedianVals=NaN(size(myDataRaw));
ModeVals=NaN(size(myDataRaw));

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
            temp=cell2mat(myDataHist(i,j,k));
            
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
            NumOfProblemRegions;
        end
        
    end
end

end