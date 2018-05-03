TotRegions=174;

modality='UTE3D';
model='rSD12';

reg_num=sprintf('%d', TotRegions);
folder='Atlas_Map_Files';
an_num=sprintf('%d', 4);
Subject=strcat(model, '_', an_num, '_', modality);
scn_num=sprintf('%d', 5);
file=strcat('map_', Subject, '_UTEscan', scn_num, '_MAGNITUDE_IMAGE_', reg_num ,'_REGION');
loadname=strcat(folder, '\', file, '.nii');
ATLASNii=load_nii(loadname);
ATLASimg=double(ATLASNii.img);
HeatMapAtlasImg=ATLASimg;
HeatMapAtlasImg(HeatMapAtlasImg>0)=0;

for i=1:1:TotRegions
    ROI=ATLASimg;
    ROI(ROI~=i)=0;
    A=X(i,1);
    HeatMapAtlasImg=HeatMapAtlasImg+ROI*A;  
end

HeatMapNii=ATLASNii;
HeatMapNii.img=HeatMapAtlasImg*1000;
view_nii(HeatMapNii)



%%

% If we want only Regions with statistically relevant differences (make a
% copy of X then use this. 

for i=1:1:60
    if 0>(abs(XCopy(i,1))-XCopy(i,2))
        X(i,1)=XCopy(i,1)
    else
        X(i,1)=0;
    end
end