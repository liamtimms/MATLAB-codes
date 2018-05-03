n=0;
aveAFI=zeros(200,200,200);

a=size(ScanOverview.ScanTypes);

for m=1:1:a(1)
    
    if strcmp(ScanOverview.ScanTypes{m},'afi')
        TR1=ScanOverview.AFIs.AfiTRs{m,1};
        TR2=ScanOverview.AFIs.AfiTRs{m,2};
        n=TR2/TR1;
        IntensityImg_TR1=ScanOverview.AFIs.Niis{m,1}.img;
        IntensityImg_TR2=ScanOverview.AFIs.Niis{m,2}.img;
        
        
        
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
        
        %     AFInii=IntensityNii_TR1;
        AFInii=ScanOverview.AFIs.Niis{m,1};
        AFInii.img=AFIimg;
        view_nii(AFInii)
        
        ScanOverview.AFIs.AfiImage{m,1}=AFIimg;
        %     file=strcat(Subject, '_scan', scn_num, '_',t1,'TR1_',t2,'TR2_AFI_IMAGE');
        %     savename=strcat(folder2, '\', file, '.nii');
        %     save_nii(AFInii,savename);
        
        
        %     aveAFI=aveAFI+AFIimg;
        %     n=n+1;
    end
end

% aveAFI=aveAFI/n;
% AFInii=ScanOverview.AFIs.Niis{m,1};
%     AFInii.img=aveAFI;
%     view_nii(AFInii)

%%
% for k=1:1:s(3)
%     data=nonzeros(AFIimg(:,:,k));
%     AveZ=nanmean(
%
% end
