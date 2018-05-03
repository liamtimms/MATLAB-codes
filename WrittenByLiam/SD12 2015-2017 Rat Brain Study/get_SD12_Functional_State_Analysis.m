function [MeanData, StdData, Mean_Diff, Mean_Diff_Error, Mean_Diff_Ttest, Mean_Diff_pVal] =get_SD12_Functional_State_Analysis(Vals, alpha, NumStates, NumReg)

%Designed to work after modes, means, etc. have been found by
%CAG_Code_v3_LT

for i=1:1:NumStates
    
    for k=1:1:NumReg
        
        MeanData(i,k)=nanmean(Vals(i,:,k));
        StdData(i,k)=nanstd(Vals(i,:,k));

    end
end


for k=1:1:NumReg
    Mean_Diff(k,1)=MeanData(1,k)-MeanData(2,k);
    Mean_Diff(k,2)=MeanData(3,k)-MeanData(2,k);
    Mean_Diff(k,3)=MeanData(3,k)-MeanData(1,k);
    
    Mean_Diff_Error(k,1)=(StdData(1,k)^2+StdData(2,k)^2)^(1/2);
    Mean_Diff_Error(k,2)=(StdData(3,k)^2+StdData(2,k)^2)^(1/2);
    Mean_Diff_Error(k,3)=(StdData(3,k)^2+StdData(2,k)^2)^(1/2);
    
    [Mean_Diff_Ttest(k,1),Mean_Diff_pVal(k,1)]=ttest2(Vals(1,:,k),Vals(2,:,k),'alpha',alpha);
    [Mean_Diff_Ttest(k,2),Mean_Diff_pVal(k,2)]=ttest2(Vals(3,:,k),Vals(2,:,k),'alpha',alpha);
    [Mean_Diff_Ttest(k,3),Mean_Diff_pVal(k,3)]=ttest2(Vals(3,:,k),Vals(1,:,k),'alpha',alpha);    
end


end