function [BestXi,BestYi,BestNumPeaks] = get_SD12_Characterization(DataObject,TotRegions)

for n=1:1:TotRegions+1
    DataForHist=0;
    
    for i=1:1:12
        newData=DataObject{i,n};
        newData=newData';
        DataForHist=[newData DataForHist];
    end
    
    [counts,bins] = hist(DataForHist);
    VectorOfCounts(n,:)=counts(:);
    VectorOfBins(n,:)=bins(:);
    X(:,1)=bins(:);
    X(:,2)=counts(:);
    
    signal=X;
    %             center=(max(bins)-min(bins))/2;
    center=0;
    window=0;
    peakshape=0;
    extra=0;
    NumTrials=5;
    
    BestGOF=0;
   
%     What I want to do is to make a part of the function that tries out different numbers of peaks and picks the best one.
%     I am kind of failing at that though.
%
%     NumPeaks=1;
%     GOF=zeros(1,NumPeaks);
%     
%     while GOF(1,:)<.9 || NumPeaks<4
%         
%         [~,GOF,~,~,~,xi,yi]=peakfit(signal,center,window,NumPeaks,peakshape,extra,NumTrials);
%         
%         for j=1:1:NumPeaks;
%             if GOF(1,j)>BestGOF
%                 BestGOF=GOF;
%                 BestNumPeaks=NumPeaks;
%                 BestXi=xi;
%                 BestYi=yi;
%             end
%         end
%         
%         clear xi yi
%         NumPeaks=NumPeaks+1;
%         GOF=zeros(1,NumPeaks);
%     end
% 

end