%% New Atlas Maker

modality='UTE3D';
model='rSD12';
TotRegions=174; %either 59, 106 or 174

reg_num=sprintf('%d', TotRegions);
new_reg_num=sprintf('%d', max(AtlasKey));

for i=1:1:12
    an_num=sprintf('%d', i);
    folder2='Atlas_Map_Files';
    folder3='Atlas_Map_Files_test';
    Subject=strcat(model, '_', an_num, '_', modality);
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    type='MAGNITUDE';
    scn_num=sprintf('%d', totscan);
    file=strcat('map_', Subject, '_MAGNITUDE_IMAGE_', reg_num ,'_REGION');
    loadname=strcat(folder2, '\', file, '.nii');
    ATLASNii=load_nii(loadname);
    ATLASimg=double(ATLASNii.img);
    
    newATLASNii=ATLASNii;
    NewAtlasImg=zeros(size(ATLASimg));
    
    for n=1:1:TotRegions
        temp=ATLASimg;
        temp(temp~=n)=0;
        temp(temp~=0)=AtlasKey(n);
        NewAtlasImg=NewAtlasImg+temp;
        
    end
    
    newATLASNii.img=NewAtlasImg;
    
    file=strcat('map_', Subject, '_MAGNITUDE_IMAGE_', new_reg_num ,'_REGION');
    savename=strcat(folder3, '\', file, '.nii');
    save_nii(newATLASNii, savename);    
    
end

%%

file=strcat('map_Rat_Atlas');
loadname=strcat(folder2, '\', file, '.nii');
ATLASNii=load_nii(loadname);
ATLASimg=double(ATLASNii.img);

newATLASNii=ATLASNii;
NewAtlasImg=zeros(size(ATLASimg));

for n=1:1:TotRegions
    temp=ATLASimg;
    temp(temp~=n)=0;
    temp(temp~=0)=AtlasKey(n);
    NewAtlasImg=NewAtlasImg+temp;
    
end

newATLASNii.img=NewAtlasImg;

file=strcat('map_Rat_Atlas_', new_reg_num ,'_REGION');
savename=strcat(folder3, '\', file, '.nii');
save_nii(newATLASNii, savename);
