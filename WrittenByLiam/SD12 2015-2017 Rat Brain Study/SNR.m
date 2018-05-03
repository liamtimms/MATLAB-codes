
NumReg=174;
NumAns=12;
NumScans=5;
modality='UTE3D';
model='rSD12';
reg_num=sprintf('%d', NumReg);
folder1='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_MAGS_RENAMED';
folder3='SD12_RAT_EXTRACTED_ALIGNED';
folder2='Atlas_Map_Files';

for j=2:10:NumAns
    j
    an_num=sprintf('%d', j);
    Subject=strcat(model, '_', an_num, '_', modality);
    type='MAGNITUDE';
    
    scn_num=sprintf('%d', 1);
    file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE-label');
    %         file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE');
    loadname=strcat(folder3, '\', file, '.nii');
    LabelNii=special_load_nii(loadname);
    LabelImg=double(LabelNii.img);
    
    
    file=strcat('map_', Subject, '_MAGNITUDE_IMAGE_', reg_num ,'_REGION');
    loadname=strcat(folder2, '\', file, '.nii');
    ATLASNii=load_nii(loadname);
    ATLASimg=double(ATLASNii.img);
    
    for m=1:1:NumScans
        scn_num=sprintf('%d', m);
        file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        %         file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE');
        loadname=strcat(folder1, '\', file, '.nii');
        IntensityNii=load_nii(loadname);
        IntensityImg=double(IntensityNii.img);
        
        ROI=LabelImg;
        ROI(ROI~=0)=1;
        [TotAve, TotStd, ~, ~, ~, ~, ~, ~, AveZ, ~, StdZ]=get_inhomo(IntensityImg, ROI);
        TotalAve(m,j)=TotAve;
        TotalStd(m,j)=TotStd;
        ZAve(m,j,:)=AveZ(:);
        ZStd(m,j,:)=StdZ(:);
        
        CorrectedStd(m,j)=TotStd/(2-pi/2)^.5;
        for n=1:1:180
            SNR(m,j,n)=MeanVals_Intensity(m,j-1,n)/CorrectedStd(m,j);
            
        end
        %         for n=1:1:NumRegs
        %             ROI=ATLASimg;
        %             if n<NumRegs
        %                 ROI(ROI~=n)=0;
        %             end
        %             ROI(ROI~=0)=1;
        %             CurrentData=IntensityImg.*ROI;
        %             s=size(CurrentData);
        %
        %             [TotAve, TotStd, AveX, NormAveX, StdX, AveY, NormAveY, StdY, AveZ, NormAveZ, StdZ]=get_inhomo(IntensityImg, ROI);
        %             TotalAve(j,m,n)=TotAve;
        %         end
        
    end
end