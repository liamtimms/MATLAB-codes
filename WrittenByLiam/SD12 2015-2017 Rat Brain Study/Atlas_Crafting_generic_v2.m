% Craft new Atlases from a vecmap (174x1 vector with assigned values)
type='CBV_Mode';

AtlasNii=special_load_nii('map_Rat_Atlas.nii');
AtlasImg=AtlasNii.img;

NewAtlasNii=AtlasNii;
NewAtlasImg=zeros(size(AtlasImg));

[NumOfRegions temp]=size(Vector);
if temp~=1
    fprintf('Check data structure');
end
AtlasSize=sprintf('%d',NumOfRegions);
for i=1:1:NumOfRegions
    Temp=AtlasImg;
    Temp(Temp~=i)=0;
    Temp(Temp==i)=Vector(i);
    NewAtlasImg=NewAtlasImg + Temp;  
end

NewAtlasNii.img=NewAtlasImg;
view_nii(NewAtlasNii)
%%
saveName=strcat('map_Rat_',type,'_', AtlasSize, '_Atlas.nii');
save_nii(NewAtlasNii,saveName)
