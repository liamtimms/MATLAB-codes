
NumReg=174;
NumAns=12;
NumScans=5;
modality='UTE3D';
model='rSD12';
reg_num=sprintf('%d', NumReg);
folder1='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_MAGS_RENAMED';
% folder1='SD12_RAT_EXTRACTED_ALIGNED';
folder2='Atlas_Map_Files';

for j=1:1:NumAns
    j
    an_num=sprintf('%d', j);
    Subject=strcat(model, '_', an_num, '_', modality);
    type='MAGNITUDE';
    
    file=strcat('map_', Subject, '_MAGNITUDE_IMAGE_', reg_num ,'_REGION');
    loadname=strcat(folder2, '\', file, '.nii');
    ATLASNii=load_nii(loadname);
    ATLASimg=double(ATLASNii.img);
    
    for m=1:1:NumScans
        scn_num=sprintf('%d', m);
        file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
%         file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE');
        loadname=strcat(folder1, '\', file, '.nii');
        IntensityNii=special_load_nii(loadname);
        IntensityImg=double(IntensityNii.img);
        
        ROI=ATLASimg;
        ROI(ROI~=0)=1;
        CurrentData=IntensityImg.*ROI;
        s=size(CurrentData);
        
        Data=nonzeros(CurrentData(:,:,s(3)/2));
        MidAve=nanmean(Data);
        for i=1:1:s(1)
            Data=nonzeros(CurrentData(i,:,:));
            AveX(i,j,m)=nanmean(Data);
            NormAveX(i,j,m)=AveX(i,j,m)/MidAve;
            %              NormAveX2(i,n)=AveX(i,n)-MidAve;
            StdX(i,j,m)=nanstd(Data);
        end
        Data=nonzeros(CurrentData(:,s(2)/2,:));
        MidAve=nanmean(Data);
        for i=1:1:s(2)
            Data=nonzeros(CurrentData(:,i,:));
            AveY(i,j,m)=nanmean(Data);
            NormAveY(i,j,m)=AveY(i,j,m)/MidAve;
            %             NormAveY2(i,n)=AveY(i,n)-MidAve;
            StdY(i,j,m)=nanstd(Data);
        end
        Data=nonzeros(CurrentData(:,:,s(3)/2));
        MidAve=nanmean(Data);
        for i=1:1:s(3)
            Data=nonzeros(CurrentData(:,:,i));
            AveZ(i,j,m)=nanmean(Data);
            NormAveZ(i,j,m)=AveZ(i,j,m)/MidAve;
            %             NormAveZ2(i,n)=AveZ(i,n)-MidAve;
            StdZ(i,j,m)=nanstd(Data);
        end
        
        
    end
end
