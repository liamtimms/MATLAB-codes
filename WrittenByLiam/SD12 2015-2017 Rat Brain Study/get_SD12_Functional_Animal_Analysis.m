function [Diff, Diff_Mean, Diff_Std, Diff_Ttest, Diff_pVal] =get_SD12_Functional_Animal_Analysis(Vals, alpha, NumStates, NumAn, NumReg)

for i=1:1:NumStates
    
    for k=1:1:NumReg
        
        MeanData(i,k)=nanmean(Vals(i,:,k));
        StdData(i,k)=nanstd(Vals(i,:,k));
        
    end
end

if NumStates==3
    for k=1:1:NumReg
        for j=1:1:NumAn
            
            Diff(j,k,1)=Vals(1,j,k)-Vals(2,j,k);
            Diff(j,k,2)=Vals(3,j,k)-Vals(2,j,k);
            Diff(j,k,3)=Vals(3,j,k)-Vals(1,j,k);
        end
        
        
        for n=1:1:NumStates
            Diff_Mean(k,n)=nanmean(Diff(:,k,n));
            Diff_Std(k,n)=nanstd(Diff(:,k,n));
            [Diff_Ttest(k,n), Diff_pVal(k,n)]=ttest(Diff(:,k,n));
        end
        
    end
else
    fprintf('This function is only designed to compare 3 states')
end

end