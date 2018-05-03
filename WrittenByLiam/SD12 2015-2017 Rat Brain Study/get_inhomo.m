function [TotAve, TotStd, AveX, NormAveX, StdX, AveY, NormAveY, StdY, AveZ, NormAveZ, StdZ]=get_inhomo(IntensityImg, ROI)

ROI(ROI~=0)=1;
CurrentData=IntensityImg.*ROI;
s=size(CurrentData);

Data=nonzeros(CurrentData);
TotAve=nanmean(Data);
TotStd=nanstd(Data);

Data=nonzeros(CurrentData(:,:,s(3)/2));
MidAve=nanmean(Data);
for i=1:1:s(1)
    Data=nonzeros(CurrentData(i,:,:));
    AveX(i)=nanmean(Data);
    NormAveX(i)=AveX(i)/MidAve;
    %              NormAveX2(i,n)=AveX(i,n)-MidAve;
    StdX(i)=nanstd(Data);
end
Data=nonzeros(CurrentData(:,s(2)/2,:));
MidAve=nanmean(Data);
for i=1:1:s(2)
    Data=nonzeros(CurrentData(:,i,:));
    AveY(i)=nanmean(Data);
    NormAveY(i)=AveY(i)/MidAve;
    %             NormAveY2(i,n)=AveY(i,n)-MidAve;
    StdY(i)=nanstd(Data);
end
Data=nonzeros(CurrentData(:,:,s(3)/2));
MidAve=nanmean(Data);
for i=1:1:s(3)
    Data=nonzeros(CurrentData(:,:,i));
    AveZ(i)=nanmean(Data);
    NormAveZ(i)=AveZ(i)/MidAve;
    %             NormAveZ2(i,n)=AveZ(i,n)-MidAve;
    StdZ(i)=nanstd(Data);
end


end