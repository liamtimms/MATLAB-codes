function [MyDataSeg] =get_SegmentationSD12(myDataRaw, numberOfClusters)

stopTolerance=1e-6;
numberOfRuns=500;

[a b c]=size(myDataRaw);
ProblemRegions=0;

for i=1:1:a
    i
    NumOfProblemRegions=0;
    
    for j=1:1:b
        j;
        for k=1:1:c
            k;
            Data=cell2mat(myDataRaw(i,j,k));
%             [xi,~,Vals] = find(Data);
            if isempty(Data)
                NumOfProblemRegions=1+NumOfProblemRegions;
                ProblemRegions=[ProblemRegions, k];
            else
                
                [estimatedLabels, estimatedMeans, ~] = KmeansJ(Data, numberOfClusters, stopTolerance, numberOfRuns);
%                 LabeledData=Data;
%                 LabeledData(xi)=estimatedLabels(xi==xi);
%                 SegmentedImg=reshape(LabeledData,[200,200,200]);
                MyDataSeg.Labels{i,j,k}=estimatedLabels;
                MyDataSeg.Means{i,j,k}=estimatedMeans;
                
            end
            
        end
    end
    
    
    
end