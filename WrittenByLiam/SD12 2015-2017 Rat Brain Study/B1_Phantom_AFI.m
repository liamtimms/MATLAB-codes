

modality='AFI3D';
model='B1_PHANTOM_3';
folder1='B1_PHANTOM_MAGNITUDE';
folder2='B1_PHANTOM_AFI';
Subject=strcat(model, '_', modality);
type='MAGNITUDE';
NumScans=1;

TR1=6;
TR2=24;
t1=sprintf('%d', TR1);
t2=sprintf('%d', TR2);

n=TR2/TR1;

for m=9:1:9
    
    scn_num=sprintf('%d', m);
    file=strcat(Subject, '_scan', scn_num, '_',t1,'TR1_IMAGE');
    loadname=strcat(folder1, '\', file, '.nii');
    IntensityNii_TR1=special_load_nii(loadname);
    IntensityImg_TR1=double(IntensityNii_TR1.img);
    IntensityImg_TR1(IntensityImg_TR1==0)=NaN;
    
    file=strcat(Subject, '_scan', scn_num, '_',t2,'TR2_IMAGE');
    loadname=strcat(folder1, '\', file, '.nii');
    IntensityNii_TR2=special_load_nii(loadname);
    IntensityImg_TR2=double(IntensityNii_TR2.img);
    IntensityImg_TR2(IntensityImg_TR2==0)=NaN;
    
    s=size(IntensityImg_TR1);
    if s~=size(IntensityImg_TR2)
        fprintf('Bro, wtf. The TR images are different sizes')
    else
        rImg=IntensityImg_TR2./IntensityImg_TR1;
        for i=1:1:s(1)
            for j=1:1:s(2)
                for k=1:1:s(3)
                    x=(n*rImg(i,j,k)-1)/(n-rImg(i,j,k));
                    
                    if abs(x)<1
                        AFIimg(i,j,k)=rad2deg(acos(x));
                    else
                        AFIimg(i,j,k)=NaN;
                    end
                end
            end
        end
    end
    
    AFInii=IntensityNii_TR1;
    AFInii.img=AFIimg;
    file=strcat(Subject, '_scan', scn_num, '_',t1,'TR1_',t2,'TR2_AFI_IMAGE');
    savename=strcat(folder2, '\', file, '.nii');
    save_nii(AFInii,savename);
    
end

%%
% for k=1:1:s(3)
%     data=nonzeros(AFIimg(:,:,k));
%     AveZ=nanmean(
%     
% end
