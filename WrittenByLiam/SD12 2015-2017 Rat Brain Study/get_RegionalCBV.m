function [MeanVals_CBV] =get_RegionalCBV_SD12(MeanVals_Intensity, BloodVals)

[a b c]=size(MeanVals_Intensity);


for j=1:1:b
    for k=1:1:c
        PreCon=MeanVals_Intensity(1,j,k);
        PostCon=MeanVals_Intensity(a,j,k);
        denom=BloodVals(a,j)-BloodVals(1,j);
        CBVAnes=(PostCon-PreCon)./denom;
        
        MeanVals_CBV((a-1),j,k)=CBVAnes;
        I_T=PostCon-CBVAnes*BloodVals(a,j);
        
        for i=1:1:(a-1)
            PostCon=MeanVals_Intensity(i+1,j,k);
            DeltaI=PostCon-PreCon;
            denom=BloodVals(i+1,j)-I_T;
            blahblah=CBVAnes*(BloodVals(1,j)-I_T);
            MeanVals_CBV(i,j,k)=(DeltaI+blahblah)/denom;
        end
    end
end


end