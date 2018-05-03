n=0;
aveIntensityImg_TR1=zeros(200,200,200);
aveIntensityImg_TR2=zeros(200,200,200);
aveAFI=zeros(200,200,200);

a=size(ScanOverview.ScanTypes);
num=0;
for m=1:1:6
    
    if strcmp(ScanOverview.ScanTypes{m},'afi')
        num=num+1;
        TR1=ScanOverview.AFIs.AfiTRs{m,1};
        TR2=ScanOverview.AFIs.AfiTRs{m,2};
        IntensityImg_TR1=ScanOverview.AFIs.Niis{m,1}.img;
        IntensityImg_TR2=ScanOverview.AFIs.Niis{m,2}.img;
        [AFIimg] = get_AFIcalculation(IntensityImg_TR1,IntensityImg_TR2, TR1, TR2);
        
        aveIntensityImg_TR1=aveIntensityImg_TR1+IntensityImg_TR1;
        aveIntensityImg_TR2=aveIntensityImg_TR2+IntensityImg_TR2;
        aveAFI=aveAFI+AFIimg;
        
        %     AFInii=IntensityNii_TR1;
        AFInii=ScanOverview.AFIs.Niis{m,1};
        AFInii.img=AFIimg;
        view_nii(AFInii)
        
        ScanOverview.AFIs.AfiImage{m,1}=AFIimg;
        %     file=strcat(Subject, '_scan', scn_num, '_',t1,'TR1_',t2,'TR2_AFI_IMAGE');
        %     savename=strcat(folder2, '\', file, '.nii');
        %     save_nii(AFInii,savename);
            
    end
end

[aveAFI2] = get_AFIcalculation(aveIntensityImg_TR1,aveIntensityImg_TR2, TR1, TR2);

aveAFI=aveAFI/num;
AFInii=ScanOverview.AFIs.Niis{m,1};
AFInii.img=aveAFI;
view_nii(AFInii)

AFInii.img=aveAFI2;
view_nii(AFInii)


