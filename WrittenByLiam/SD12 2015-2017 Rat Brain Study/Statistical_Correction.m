function [CorrectedDataPerRegion] = Statistical_Correction(RawImage, ATLASimg, Stds, CapMapImg, i, j)


stdforcorrection=(Stds(i,j,1)+Stds(i,j,2))/2;
TotRegions=59;

for n=1:1:TotRegions
    
    % select region
    ROI=ATLASimg;
    ROI(ROI~=n)=0;
    ROI(ROI~=0)=1;
    
    ROI=ROI.*CapMapImg;
    
    Data=RawImage.*ROI;
    
    Data(isnan(Data))=0; %WTF NANS
    Data=nonzeros(Data);
   
    
    CorrectedDataPerRegion(n)=((mean(Data))^2-stdforcorrection^2)^(.5);
    
end



end