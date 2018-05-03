function [CorrectedDataPerRegion, IntensityStd, Nvox] = Statistical_Correction_v2(RawImage, ATLASimg, Stds, CapMapImg, i, j, TotRegions)


stdforcorrection=(Stds(i,j,1)+Stds(i,j,2))/2;
HomoMap=ones(200,200,200);
HomoMap=Inhomogeneity_Correction_complex(HomoMap, 3);
StdCorrMap=HomoMap*stdforcorrection;

for n=1:1:TotRegions
    
    % select region
    ROI=ATLASimg;
    ROI(ROI~=n)=0;
    ROI(ROI~=0)=1;
    
    ROI=ROI.*CapMapImg;
    
    Data=RawImage.*ROI;
    
    Data(isnan(Data))=0; %WTF NANS
    Data=nonzeros(Data);
    s=size(Data);
    Nvox(n)=s(1,1);
    
    DataCorrection=StdCorrMap.*ROI;
    DataCorrection=nonzeros(DataCorrection);
    stdforcorrection=mean(DataCorrection);
    CorrectedDataPerRegion(n)=((mean(Data))^2-stdforcorrection^2)^(.5);
    IntensityStd(n)=std(Data);
    
    
end



end